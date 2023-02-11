// ----------- DATABASE & CONNECTION-------------
const { exec } = require('child_process');
const { error } = require('console');
const { stopCoverage } = require('v8');
const db = require('../../../config/db_connect');    // Database connection

// -------------- LOGGING & PATH ----------------
// const mainLogger = require('../../domain/Model/mainLogger');

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

const event_type = ['image', 'form', 'video'];

class EventController {
        // + Начальные настройки на странице редактора, отправка на рендеринг страницы .ejs
    async getEvents(req, res) {
        if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor'))) {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }
        const title = "EditPanel";

        res.render(createPath('editor'), { title, session: req.session });
    }
        // Получение списка шаблонов для открытия
    async allTemplates(req, res) {
        const alltmp1 = await db('tmp').select('*').where('canview', true);
        const alltmp2 = await db('tmp').select('*').where('author', req.session.username).where('canview', false);

        if (alltmp1[0] === undefined && alltmp2[0] === undefined)
            res.end();
        else if (alltmp2[0] === undefined)
            res.json(alltmp1);
        else if (alltmp1[0] === undefined)
            res.json(alltmp2);
        else
            res.json(alltmp1.concat(alltmp2));
    }
        // Создать новый шаблон (по умолчанию с веб-формами)
    async createTemplate(req, res) {
        const { name, tmp_type } = req?.body;

        if (name.length <= 30 || name !== undefined) {
            const tmpHere = await db('tmp').select('*').where("name", name);
            if (tmpHere[0] === undefined) {
                    // Создаем сам шаблон 
                await db('tmp').insert({
                    name: name, 
                    author: req.session.username,
                    isprivate: true,    // default
                    canview: false      // default
                });
                    // В зависимости от типа нового шаблона создаем 
                const tmp = await db('tmp').select("*").where({ name });
                switch(tmp_type) {
                    case 'empty':       // Пустой шаблон
                        
                        break;
                    case 'copy':        // Копия шаблона
                        const { events } = req?.body;   

                        if (events[0].name === 'empty' && events[0].src === 'empty') {
                            // Обработка пустого шаблона
                        } else {
                                // Заполнение таблицы обновленным списком событий
                            var order = 1;
                            for (var i in events) {
                                try {
                                    await db('events_tmp').insert({
                                        name: events[i].name, 
                                        src: events[i].src, 
                                        time: events[i].time, 
                                        type: events[i].type, 
                                        order: order, 
                                        isActive: true,
                                        tmpid: tmp[0].id
                                    });
                                    order++;
                                } catch (e) {
                                    //  Обработать некорректное событие 
                                }
                            }
                        }

                        break;
                    case 'default':     // Шаблон по умолчанию
                        await db('events_tmp').insert({
                            name: "Карта К3", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 1, 
                            tmpid: tmp[0]?.id
                        });
                        await db('events_tmp').insert({
                            name: "Карта Артек", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 2, 
                            tmpid: tmp[0]?.id
                        });
                        await db('events_tmp').insert({
                            name: "К3 - Артек", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 3, 
                            tmpid: tmp[0]?.id
                        });
                        await db('events_tmp').insert({
                            name: "Аудитории - Гидра", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 4, 
                            tmpid: tmp[0]?.id
                        });
                        await db('events_tmp').insert({
                            name: "Гидра - Влажность", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 5, 
                            tmpid: tmp[0]?.id
                        });
                        await db('events_tmp').insert({
                            name: "Гидра - Температура", 
                            src: 'http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/',
                            isActive: true, // default
                            type: 1,        // web-form
                            time: 15,       // 15 sec
                            order: 6, 
                            tmpid: tmp[0]?.id
                        });
                        break;
                    default:

                        break;
                }

                // const templates = await db('events_tmp').select("*").where('tmpid', tmp[0].id).orderBy('order');
                // for (let i in templates) {
                //     templates[i].isauthor  = true;
                //     templates[i].isprivate = tmp[0].isprivate;
                //     templates[i].canview = tmp[0].canview;
                // }
                
                res.end();
            } 
        }

        res.end();
    }
        // Удаление шаблона шаблон 
    async deleteTemplate(req, res) {
        const { name } = req?.body;
        const tmp = await db('tmp').select("*").where("name", name);

        if (tmp[0] !== undefined) {
            if (req.session.username === tmp[0]?.author) {
                await db('events_tmp').select("*").where('tmpid', tmp[0].id).del();
                await db('tmp').select("*").where('name', name).del();
            } 
        }

        res.end();
    }

        // Открыть шаблон - получение списка событий
    async getTemplate(req, res) {
        const { name } = req?.body;
        const tmp = await db('tmp').select('*').where("name", name);
        
        if (tmp[0] !== undefined) {
            if (tmp[0] === undefined) { 
                console.log("Template with name: " + name + " not found. "); 
                res.end(); 
            } else if (tmp[0].canview || tmp[0].author === req.session.username) { 
                var events = await db('events_tmp')
                                            .where('tmpid', tmp[0]?.id)
                                            .select('*')
                                            .orderBy('order');
                if (events[0] === undefined) {
                    events[0] = { 
                        name: "undef",
                        src:  "undef"
                    };
                } 

                for (let i in events) {
                    events[i].isauthor  = (tmp[0].author === req.session.username);
                    events[i].isprivate = tmp[0].isprivate;
                    events[i].canview   = tmp[0].canview;
                }

                res.status(200).json(events);
            }
        } else {
            res.status(400).json([{ name: "none", src: "none" }]);
        }   

        res.end();
    }
        // Сохранение изменений внутри шаблона
    async saveTemplate(req, res) {
        const events = req?.body;    // Список событий, прилетевший с формы
        const tmpName = events[0]?.openedtmp;

            // Шаблон, в который прилетают изменения
        const tmp = await db('tmp').update({
            last_modify: req.session?.username
        }).where('name', tmpName).returning("*");
            // Шаблон не может быть не виден другим пользователям, если разрешено его редактирование
        if (!events[0].canview)
            events[0].isprivate = true;
        await db('tmp').select("*").where('name', tmpName).update({ 
            isprivate: events[0].isprivate,
            canview: events[0].canview
        });
        await db('events_tmp').where('tmpid', tmp[0].id).del();  // Очистка таблицы событий

        if (events[0].name === 'empty' && events[0].src === 'empty') {
            // Обработка пустого шаблона
        } else {
                // Заполнение таблицы обновленным списком событий
            var order = 1;
            for (var i in events) {
                try {
                    await db('events_tmp').insert({
                        name: events[i].name, 
                        src: events[i].src, 
                        time: events[i].time, 
                        type: events[i].type, 
                        order: order, 
                        isActive: true,
                        tmpid: tmp[0].id
                    });
                    order++;
                } catch (e) {
                    //  Обработать некорректное событие 
                }
            }
        }

        res.end();
    }

        // Выдача логов на чтение
    async logRead(req, res) {
        if (!(req.session.loggedin && (req.session.role === 'admin'))) {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        const title  = "Logs";
        var logData  = [];      // Результирующий лог
        var logGroup = [];      // Группы логов 
        var logRes   = [];
        
            // Выборка действий только с событиями и объединение в группы логов
        const groupMax = await db('log').select('*').where('object', 'event').orderBy('e_group', 'desc');
        try {
            var group = groupMax[0].e_group;
               // Тупо все события по порядку действий (дата + время)
            for (let i = 1; i < group + 1; i++) {
                const bigLog = await db('log').select('*').where('object', 'event').where('e_group', i).orderBy('date', 'asc').orderBy('time', 'asc');
                logGroup.push(bigLog);
            }

            const miniLog = await db('log').select('*').orderBy('date', 'time').where('object', 'ads');

                // ОБЪЕДИНЕНИЕ 
            for (let i in logGroup)
                logData.push(logGroup[i]);
            for (let i in miniLog) 
                logData.push(miniLog[i]);

            var logId = [];
            for (let i in logData) {
                try {
                    logId.push(logData[i][0].id);
                } catch (err) {
                    logId.push(logData[i].id);
                }
            }
            
            logId.sort();

            var id;     // АЙДИШНИК ИЗ ЗАПИСИ СОБЫТИЯ ИЛИ ОБЪЯВЛЕНИЯ
            for (let i in logId) {
                for (let j in logData) {
                    try {
                        id = logData[j][0].id;
                    } catch (cock) {
                        id = logData[j].id;
                    }
                    if (logId[i] == id) {
                        logRes.push(logData[j])
                    }
                }
            }
        } catch (biba) {
            logRes = [''];
        }

        res.render(createPath('logview'), { title, logData: logRes, session: req.session });
    }
        // + Отправка на трансляцию (get) 
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
        });}
        res.json({ pages: event_json });
    }
}

module.exports = new EventController() 