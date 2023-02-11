const db = require('../../../config/db_connect');    // Database connection

// -------------- LOGGING & PATH ----------------
const mainLogger = require('../../domain/Model/mainLogger');

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

const event_type = ['image', 'form', 'video'];

class ModerController {

    async getRequests(req, res) {

    }


}

module.exports = new ModerController() 