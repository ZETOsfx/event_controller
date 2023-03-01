const { ReadableStreamBYOBRequest } = require("node:stream/web");
const { postgresMd5PasswordHash } = require("pg/lib/utils");

const db = require('../../../config/db_connect');    // Database connection
const argon2 = require('argon2')

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

class UserController {
    // Register (async method)
    async registerAsync(req, res) {
        const { name, password, role } = req.body;
        const hashedPassword = await argon2.hash(password);
        await db('ec_user').insert({ name: name, role: role, passhash: hashedPassword });
        
        // const _ads = await db('ads').select('*').orderBy('id');
        res.redirect('/account/register');
        res.end();
    }
    // All profiles
    async getUsers(req, res) {
        const users = await db.select('*').from('ec_user');
        res.json(users.rows);
    }
    // Sign in (async method)
    async signInAsync(req, res, next) {
        const title = "Login";
        let message = 0;
        const { name, password } = req.body;
        const user = await db.select('*').from('ec_user').where('name', name);
        if (!user[0]) {
            message = 1;    // Пользователь не найден
        } else {
            const correctPassword = await argon2.verify(user[0].passhash, password);
            if (!correctPassword) {
                message = 2;    // Пароль не верный
            } else {
                    // Correct data
                req.session.save( async (err) => {
                    if (err) {
                        return next(err);
                    }

                        // Profile data
                    const user = await db('ec_user').select('*').where('name', name);

                        // Актуальные события (общие)
                    const _ads = await db('ads').select('*').where('personal', null);

                        // Персональные уведомления (только для данного профиля)
                    const personal_ads = await db('ads').select('*').where('personal', user[0].name)

                        // Список сообщений, которые данный пользователь уже просмотрел
                    const userAds = await db('user_ads').select('*').where('user_id', user[0].id);

                    req.session.noread = _ads.length + personal_ads.length - userAds.length;

                    req.session.loggedin = true;
                    req.session.username = name;
                    req.session.role = user[0].role;

                    if (user[0].role === 'admin' || user[0].role === 'moder') {
                        const req_moder = await db('events_req_form').select('*').where('isAccepted', false);
                        req.session.moder_req = req_moder.length;
                    }

                    res.status(200).redirect('/index');
                });
            }
        }
        if (message !== 0)
            res.render(createPath('login'), { title, session: req.session, message });
    }

    async logoutAsync(req, res) {
        req.session.loggedin = false;
        req.session.username = null;
        req.session.role = null;
        res.redirect('/account/login');
    }
    // Update user data
    async updateUser(req, res) {
        const { id, role } = req.body;
        // const hashedPassword = await argon2.hash(password);
        const user = await db('ec_user')
            .where('id', id)
            .update({
                // name: name,
                // passhash: hashedPassword,
                role: role
            });
        res.redirect('../account/register');
    }
    // Delete user
    async deleteUser(req, res) {
        const { id } = req.body;
        const name = await db('ec_user').select('name').where('id', id);

        let indexOfTemplateToDelete = [];
        const tmp = await db('tmp').select('id').where('author', name[0].name);

        for (let i in tmp)
            await db('events_tmp').select('*').where('tmpid', tmp[i].id).del();

        await db('tmp').select('*').where('author', name[0].name).del();
        await db('ec_user').where('id', id).del();
        await db('user_ads').where('user_id', id).del();
        res.redirect('../account/register');
    }
}

module.exports = new UserController() 