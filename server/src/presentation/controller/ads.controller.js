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
        const { name, comment, time, translate } = req?.body;
    
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

            // Логгирование 
        let date_ob = new Date();
            // current date
            // adjust 0 before single digit date
        let dd = ("0" + date_ob.getDate()).slice(-2);
            // current month
        let mm = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            // current year
        let yyyy = date_ob.getFullYear();
            // current hours
        let hour = date_ob.getHours();
        if (hour < 10) hour = "0" + hour;
            // current minutes
        let min = date_ob.getMinutes();
        if (min < 10) min = "0" + min;
            // current seconds
        let sec = date_ob.getSeconds();
        if (sec < 10) sec = "0" + sec;

            // Date + time (format needed)
        let dateNow = dd + '-' + mm + '-' + yyyy;
        let timeNow = hour + ':' + min + ':' + sec;
        mainLogger.pushAdsLog(1, dateNow, timeNow, req.session?.username,  req.session?.username, name, comment, translate, time);
        mainLogger.syncLoggerWithDatabase(req.session?.username, 'ads');

        req.session.noread = 0;
        res.redirect('../ads');
    }
        // Удаление объявления 
    async deleteAds(req, res) {
        const { id } = req.body;
        const ad = await db('ads').where('id', id);
    
            // Логгирование 
        let date_ob = new Date();
            // current date
            // adjust 0 before single digit date
        let dd = ("0" + date_ob.getDate()).slice(-2);
            // current month
        let mm = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            // current year
        let yyyy = date_ob.getFullYear();
            // current hours
        let hour = date_ob.getHours();
        if (hour < 10) hour = "0" + hour;
            // current minutes
        let min = date_ob.getMinutes();
        if (min < 10) min = "0" + min;
            // current seconds
        let sec = date_ob.getSeconds();
        if (sec < 10) sec = "0" + sec;
        
            // Date + time (format needed)
        let dateNow = dd + '-' + mm + '-' + yyyy;
        let timeNow = hour + ':' + min + ':' + sec;
        mainLogger.pushAdsLog(0, dateNow, timeNow, req.session.username, ad[0].author, ad[0].name, ad[0].comment, ad[0].translate, ad[0].timeOfLife, false);
        mainLogger.syncLoggerWithDatabase(req.session.username, 'ads');

            // Удаление из числа прочитанных (если было прочитано)
        await db('user_ads').where('ads_id', id).del();
            // Удаление из базы уведомлений
        await db('ads').where('id', id).del();

        res.redirect('/ads');
        res.end();
    }
        // Получение списка объявлений для внутреннего окна
    async getAds(req, res) {
        var ads, title = 'Ads';
            // В зависимости от факта авторизации выводим объявления разного уровня доступа 
        if (req.session.loggedin) {
                // Чем меньше значение ID, тем ранее добалено объявление 
            ads = await db('ads').select('*').orderBy('id');    // [ json ]
                // + Помещаем все события в список
            const user = await db('ec_user').select('*').where('name', req.session.username);
            const userAds = await db('user_ads').select('*').where('user_id', user[0].id);
                // Если записи о данном объявлении нет, то добавляем в таблицу
            var isHere;     // flag
            for (var i in ads) {
                isHere = false;
                for (var j in userAds) {
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
            ads = await db('ads').select('*').where('translate', 'true').orderBy('id');
    
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