const db = require('../../../config/db_connect');    // Database connection

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

class ApiController {

        // Отправка на трансляцию (get)
    async getEventsFormatJSON(req, res) {
        res.header('Access-Control-Allow-Origin', '*');
        const events = await db.where('isActive', true)
            .select('*')
            .from('events')
            .orderBy('order');
        var event_json = [];
        var datetime_order = (new Date()).getTime();
        for (var i in events) {
            event_json.push({
                time: new Date(datetime_order),
                type: event_type[events[i].type],
                src:  events[i].src
            });
            datetime_order += events[i].time * 1000;
        }

        {
            event_json.push({
                time: new Date(datetime_order),
                type: "end",
                src:  "src"
            });
        }
        res.json({ pages: event_json });
    }

}

module.exports = new ApiController();