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
            const data = await db('events_req_form').select('*');
            res.json(data);

        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }       
}

module.exports = new ModerController() 