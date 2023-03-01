// ----------- DATABASE & CONNECTION-------------
const { stopCoverage } = require('v8');
const db = require('../../../config/db_connect');    // Database connection
// ------------------ SESSION -------------------
const { exec } = require('child_process');
// -------------- LOGGING & PATH ----------------
const mainLogger = require('../../domain/Model/mainLogger');
const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

class AdsController {
        // Добавление объявления (функционал оповестителя)
    async addAds(req, res) {
        const { name, comment, translate, unlimited } = req?.body;
        let { time } = req?.body;

        if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'moder' || req.session.role === 'adsender'))) {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }

        if (unlimited) {
            time = "9999-01-01";
        }

        await db('ads').insert({
            name: name,                     // Заголовок
            comment: comment,               // Содержание 
            timeOfLife: time,               // Время актуальности
            author: req.session?.username,   // Автор
            translate: translate            // Необходимость транслировать объявление
        });

        const ads = await db('ads').select('*').where('name', name);   
        const user = await db('ec_user').select('*').where('name', req.session?.username);
            // Уведомитель автоматически "читает" сообщения
        await db('user_ads').insert({
            user_id: user[0].id,
            ads_id: ads[0].id
        });

        req.session.noread = 0;
        res.redirect('../ads');
    }
        // Удаление объявления 
    async deleteAds(req, res) {
        const { id } = req.body;
        const ad = await db('ads').where('id', id);

        if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'moder' || req.session.role === 'adsender'))) {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }

            // Удаление из числа прочитанных (если было прочитано)
        await db('user_ads').where('ads_id', id).del();
            // Удаление из базы уведомлений
        await db('ads').where('id', id).del();

        res.redirect('/ads');
        res.end();
    }
        // Получение списка объявлений для внутреннего окна
    async getAds(req, res) {
        let ads, title = 'Ads';
            // В зависимости от факта авторизации выводим объявления разного уровня доступа 
        if (req.session.loggedin) {
                // Profile data
            const user = await db('ec_user').select('*').where('name', req.session.username);
                // Get ads
            ads = await db('ads').select('*').orderBy('id', 'desc').where(function() {
                this.where('personal', null).orWhere('personal', user[0].name)
            });
                // + Ads to List
            const userAds = await db('user_ads').select('*').where('user_id', user[0].id);

                // Если записи о данном объявлении нет, то добавляем в таблицу
            let isHere;
            for (let i in ads) {
                isHere = false;
                for (let j in userAds) {
                    if (ads[i].id === userAds[j].ads_id)
                        isHere = true;
                }
                if (!isHere) {
                    await db('user_ads').insert({
                        user_id: user[0].id,
                        ads_id: ads[i].id
                    });
                }
            }
            req.session.noread = 0;
        } else
            ads = await db('ads').select('*').where('translate', 'true').orderBy('id', 'desc');
    
        res.render(createPath('adsender'), { title, session: req.session, ads});
        res.end();
    }
        // Список общих объявлений (подается на трансляцию)
    async getAdsTranslate(req, res) {
        const ads = await db('ads').select('*').where('translate', 'true').orderBy('id');
        res.json(ads);
        res.status(200).end();  // ОК status
    }
}

module.exports = new AdsController();