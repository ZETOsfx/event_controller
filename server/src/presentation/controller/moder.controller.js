const db = require('../../../config/db_connect');    // Database connection

// -------------- LOGGING & PATH ----------------
// const mainLogger = require('../../domain/Model/mainLogger');

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

const event_type = ['image', 'form', 'video'];

class ModerController {

        // Загрузка списка запросов на утверждение
    async getRequests(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const data = await db('events_req_form').select('*').orderBy('date', 'asc');
            res.json(data);

        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }    
        // Активный шаблон из программы на трансляции
    async getActive(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const data = await db('events_req_form').select('*').where('isActive', true);
            res.json(data); 

        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }
        // Шаблоны для замены модератору
    async getTemplates(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {

            const alltmp1 = await db('tmp_acc').select('*');
            const alltmp2 = await db('tmp').select('*').where('author', req.session.username);

            if (alltmp1[0] === undefined && alltmp2[0] === undefined)
                res.end();
            else if (alltmp2[0] === undefined)
                res.json(alltmp1);
            else if (alltmp1[0] === undefined)
                res.json(alltmp2);
            else {
                var unique = (alltmp1.concat(alltmp2)).filter((value, index, array) => array.indexOf(value) === index);
                res.json(unique);
            }

        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }
        // Переключение процесса обработки запроса 
    async switchProcess(req, res) {
        const { name } = req.body;

        const request = await db('events_req_form').where({ name }).select('inProcessing');
        await db('events_req_form').where({ name }).update({ 
            inProcessing: !request[0].inProcessing
        });
        
        res.end();
    }
}

module.exports = new ModerController() 