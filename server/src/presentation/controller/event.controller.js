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
        if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder'))) {
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
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
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
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }
        // Создать новый шаблон (по умолчанию с веб-формами)
    async createTemplate(req, res) {
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
            const { name, tmp_type } = req?.body;

            if (name.length <= 30 || name !== undefined) {
                const tmpHere = await db('tmp').select('*').where("name", name);
                if (tmpHere[0] === undefined) {
                        // Создаем сам шаблон
                    await db('tmp').insert({
                        name: name,
                        author: req.session.username,
                        isprivate: true,    // default
                        canview: false,     // default
                        last_modify: req.session.username
                    });
                        // В зависимости от типа нового шаблона создаем
                    const tmp = await db('tmp').select("*").where({ name });
                    switch(tmp_type) {
                        case 'empty':       // Пустой шаблон
                            // let mess = 'Шаблон \"' + name + '\" был успешно создан';
                            res.json({ typecall: 'success' });
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
                            res.json({ typecall: 'success' });
                            break;
                        case 'default':     // Шаблон по умолчанию
                            await db('events_tmp').insert({
                                name: "Объявления в системе",
                                src: 'http://eventcontroller.ru/adscast',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 1,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "Карта К3",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 2,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "Карта Артек",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 3,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "К3 - Артек",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 4,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "Аудитории - Гидра",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 5,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "Гидра - Влажность",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 6,
                                tmpid: tmp[0]?.id
                            });
                            await db('events_tmp').insert({
                                name: "Гидра - Температура",
                                src: 'http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/',
                                isActive: true, // default
                                type: 1,        // web-form
                                time: 15,       // 15 sec
                                order: 7,
                                tmpid: tmp[0]?.id
                            });
                            break;
                        default:
                            res.json({ typecall: 'success' });
                            break;
                    }

                } else {
                    res.json({ typecall: 'error' });
                }
            }
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }
        // Удаление шаблона шаблон 
    async deleteTemplate(req, res) {
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
            const { name } = req?.body;
            const tmp = await db('tmp').select("*").where("name", name);

            if (tmp[0] !== undefined) {
                if (req.session.username === tmp[0]?.author) {
                    await db('events_tmp').select("*").where('tmpid', tmp[0].id).del();
                    await db('tmp').select("*").where('name', name).del();
                }
            }
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }
        // Открыть шаблон - получение списка событий
    async getTemplate(req, res) {
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
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
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }
        // Сохранение изменений внутри шаблона
    async saveTemplate(req, res) {
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
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
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }
        // Отправка шаблона на модерацию
    
    async sendTemplate(req, res) {
        if (req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'editor' || req.session.role === 'moder')) {
            const { name, screen, date, isSpec = false } = req?.body;
            let { comment, stud_name, break_name, lunch_name } = req?.body;

            if (comment === undefined)
                comment = '';

            const req_here = await db('events_req_form').select('id').where({ name });

            if (req_here[0] !== undefined) {
                res.json({ message: 'Запрос с таким заголовком уже существует. Для однозначной идентификации придумайте другой.'});
            } else {
                if (isSpec) {
                    if (name && stud_name !== '-' && screen && date) {
                        const request = await db('events_req_form').insert({
                            name: name,                         // Заголовок запроса на модерацию
                            comment: comment,                   // Комментарий редактора для модератора
                            date: date,                         // Дата, на которую хочет поставить редактор
                            isspecial: true,                    // Метка специального расписания
                            author: req.session.username,       // Автор запроса на установку
                            lesson: stud_name,                  // Программа трансляции - Время занятий
                            breaktime: stud_name,                     // Программа трансляции - Время перерыва между занятиями
                            lunch: stud_name,                         // Программа трансляции - Время обеда
                            screen: screen,                     // Экран, на который необходимо установить трансляцию
                            isAccepted: false                   // Утвержден ли запрос (утверждает модератор)
                        }).returning('*');

                        const specTemp = await db('tmp').select('*').where('name', stud_name);
                        const eventsTemp = await db('events_tmp').select('*').where('tmpid', specTemp[0].id);

                        delete specTemp[0].id;
                        specTemp[0].from = request[0].id;
                        const newTmp = await db('tmp_acc').insert(specTemp[0]).returning('*');
                        for (let i in eventsTemp) {
                            delete eventsTemp[i].id;
                            eventsTemp[i].tmpid = newTmp[0].id;
                            await db('events_tmp_acc').insert(eventsTemp[i]);
                        }
                        res.json({ message : '-'});
                    } else
                        res.json({ message: 'Некорректные параметры отправки шаблона специального типа. Проверьте правильность заполения полей в форме отправки.'});
                } else {
                    if (name && (stud_name !== '-' || break_name !== '-' || lunch_name !== '-') && screen && date) {
                        let originTemp = [];
                        let active;

                        if (stud_name !== '-') {
                            const stud_tmp = await db('tmp').select('*').where('name', stud_name);
                            originTemp.push(stud_tmp[0]);
                        } else {
                                // если оставлять без изменений, подстановка будет происходить из активной трансляции
                            active = await db('events_req_form').select('*').where('isActive', true);
                            if (!active[0]) {
                                res.json({ message: 'Нет активных шаблонов. Поля не могут быть пустыми.' });
                                res.end();
                                return;
                            }

                            if (active[0].lesson !== '-') {
                                const stud_tmp = await db('tmp').select('*').where('name', active[0].lesson);
                                stud_name = active[0].lesson;
                                originTemp.push(stud_tmp[0]);
                            } else {
                                res.json({ message: 'В активном шаблоне отсутствует программа на ПАРЫ.\nПожалуйста, заполните данное поле.' });
                                res.end();
                                return;
                            }
                        }

                        if (break_name !== '-') {
                                // Если в одном запросе стоит несколько одинаковых шаблонов, не нужно дублировать резервные копии
                            if (break_name !== stud_name) {
                                const break_tmp = await db('tmp').select('*').where('name', break_name);
                                originTemp.push(break_tmp[0]);
                            }
                        } else {
                            active = await db('events_req_form').select('*').where('isActive', true);
                            if (!active[0]) {
                                res.json({ message: 'Нет активных шаблонов. Поля не могут быть пустыми.' });
                                res.end();
                                return;
                            }

                            if (active[0].breaktime !== '-') {
                                let break_tmp = await db('tmp').select('*').where('name', active[0].breaktime);
                                break_name = active[0].breaktime;
                                originTemp.push(break_tmp[0]);
                            } else {
                                res.json({ message: 'В активном шаблоне отсутствует программа на ПЕРЕРЫВ.\nПожалуйста, заполните данное поле.' });
                                res.end();
                                return;
                            }
                        }

                        if (lunch_name !== '-') {
                            if (lunch_name !== break_name && lunch_name !== stud_name) {
                                const lunch_tmp = await db('tmp').select('*').where('name', lunch_name);
                                originTemp.push(lunch_tmp[0]);
                            }
                        } else {
                            active = await db('events_req_form').select('*').where('isActive', true);
                            if (!active[0]) {
                                res.json({ message: 'Нет активных шаблонов. Поля не могут быть пустыми.' });
                                res.end();
                                return;
                            }

                            if (active[0].lunch !== '-') {
                                let lunch_tmp = await db('tmp').select('*').where('name', active[0].lunch);
                                lunch_name = active[0].lunch;
                                originTemp.push(lunch_tmp[0]);
                            } else {
                                res.status(400).json({ message: 'В активном шаблоне отсутствует программа на ОБЕД.\nПожалуйста, заполните данное поле.' });
                                res.end();
                                return;
                            }
                        }

                        // Если все окей, заполняем поле запроса
                        const reeq = await db('events_req_form').insert({
                            name: name,                         // Заголовок запроса на модерацию
                            comment: comment,                   // Комментарий редактора для модератора
                            date: date,                         // Дата, на которую хочет поставить редактор
                            isspecial: false,                   // Метка специального расписания
                            author: req.session.username,       // Автор запроса на установку
                            lesson: stud_name,                  // Программа трансляции - Время занятий
                            breaktime: break_name,              // Программа трансляции - Время перерыва между занятиями
                            lunch: lunch_name,                  // Программа трансляции - Время обеда
                            screen: screen,                     // Экран, на который необходимо установить трансляцию
                            isAccepted: false                   // Утвержден ли запрос (утверждает модератор)
                        }).returning('*');

                        for (let j in originTemp) {
                                // Все события указанных при отправке шаблонов
                            const eventsTemp = await db('events_tmp').select('*').where('tmpid', originTemp[j].id);
                            delete originTemp[j].id;
                            originTemp[j].from = reeq[0].id;
                            const newTmp = await db('tmp_acc').insert(originTemp[j]).returning("*");
                            for (let i in eventsTemp) {
                                delete eventsTemp[i].id;
                                eventsTemp[i].tmpid = newTmp[0].id;
                                await db('events_tmp_acc').insert(eventsTemp[i]);
                            }
                        }
                        res.json({ message : '-'});
                    } else {
                        res.json({ message: 'Некорректные параметры отправки шаблона стандартного типа. Проверьте правильность заполнения полей в форме отправки.'});
                    }
                }
            }
        } else {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        res.end();
    }

        // Отправка на трансляцию (get)
    async getEventsFormatJSON(req, res) {
        res.header('Access-Control-Allow-Origin', '*');
        const events = await db.where('isActive', true)
            .select('*')
            .from('events')
            .orderBy('order');
        let event_json = [];
        let datetime_order = (new Date()).getTime();
        for (let i in events) {
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
        // Выдача логов на чтение
    async logRead(req, res) {
        if (!(req.session.loggedin && (req.session.role === 'admin'))) {
            const title = "Error";
            res
                .status(404)
                .render(createPath('error'), { title });
        }

        const title  = "Logs";
        let logData  = [];      // Результирующий лог
        let logGroup = [];      // Группы логов
        let logRes   = [];
        
            // Выборка действий только с событиями и объединение в группы логов
        const groupMax = await db('log').select('*').where('object', 'event').orderBy('e_group', 'desc');
        try {
            let group = groupMax[0].e_group;
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

            let logId = [];
            for (let i in logData) {
                try {
                    logId.push(logData[i][0].id);
                } catch (err) {
                    logId.push(logData[i].id);
                }
            }
            
            logId.sort();

            let id;     // АЙДИШНИК ИЗ ЗАПИСИ СОБЫТИЯ ИЛИ ОБЪЯВЛЕНИЯ
            for (let i in logId) {
                for (let j in logData) {
                    try {
                        id = logData[j][0].id;
                    } catch (cock) {
                        id = logData[j].id;
                    }
                    if (logId[i] === id) {
                        logRes.push(logData[j])
                    }
                }
            }
        } catch (e) {
            logRes = [''];
        }

        res.render(createPath('logview'), { title, logData: logRes, session: req.session });
    }

}

module.exports = new EventController();