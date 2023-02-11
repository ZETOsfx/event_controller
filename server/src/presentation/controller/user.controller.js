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
        var message = 0;
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
                        // Актуальные события 
                    const _ads = await db('ads').select('*').orderBy('id');     // Len
                    const user = await db('ec_user').select('*').where('name', name);
                    const userAds = await db('user_ads').select('*').where('user_id', user[0].id);  // isHere ?

                    req.session.noread = _ads.length - userAds.length;

                    req.session.loggedin = true;        // Сразу генерим профиль (чтобы каждый раз не входить снова)
                    req.session.username = name;        // ХЗ зачем
                    req.session.role = user[0].role;    // Для проверки доступа
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
        await db('ec_user').where('id', id).del();
        await db('user_ads').where('user_id', id).del();
        res.redirect('../account/register');
    }
}

module.exports = new UserController() 