const db = require('../../../config/db_connect');    // Database connection

// -------------- LOGGING & PATH ----------------
// const mainLogger = require('../../domain/Model/mainLogger');

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

class ModerController {
        // Рендеринг страницы
    async onLoad(req, res) {
        if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'moder'))) {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
        const title = "ModerPanel";
        res.status(200).render(createPath('moder'), {title, session: req.session});

    }
        // Загрузка списка запросов на утверждение
    async getRequests(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const data = await db('events_req_form').select('*').orderBy('date', 'asc').orderBy('id', 'desc');
            res.status(200).json(data);
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }
        // Шаблоны для замены модератору
    async getTemplates(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const { name } = req.body;
            const _req = await db('events_req_form').select('*').where({ name});
            const all = await db('tmp').select('*').where('author', req.session.username).where('isprivate', true);
            const orig = await db('tmp_acc').select('*').where('from', _req[0].id);

            let unique = (all.concat(orig)).filter((value, index, array) => array.indexOf(value) === index);
            res.status(200).json(unique);
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
            res.end();
        }
    }
        // Переключение процесса обработки запроса 
    async switchProcess(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const { name } = req.body;
            const request = await db('events_req_form').where({ name }).select('inProcessing');
            const reeq = await db('events_req_form').where({ name }).update({
                inProcessing: !request[0].inProcessing,
                whoAccept: req.session.username
            }).returning('whoAccept');
            res.json(reeq[0]);
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
        }
        res.end();
    }
        // Утвердить
    async Access(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const { obj_req, comment } = req?.body;
            const { has_changes, upd_less, upd_break, upd_lunch } = req?.body; 
            
            const date_check = await db('events_req_form').select('*').where('date', obj_req.date).where('isAccepted', true);
            if (date_check[0] === undefined || obj_req.isAccepted || has_changes !== undefined) {
                if (obj_req.name) {
                    const request = await db('events_req_form').select('*').where('name', obj_req.name);

                    if (request !== undefined && request[0].inProcessing && request[0].whoAccept === req.session.username) {
                            // Списки шаблонов: изначальные + на замену
                        const pre_example = [request[0].lesson, request[0].breaktime, request[0].lunch];
                        const pre_updated = [obj_req.lesson, obj_req.breaktime, obj_req.lunch];
                            // Списки шаблонов - уникальные (для избежания дублирования)
                        const example = pre_example.filter((value, index, array) => array.indexOf(value) === index);
                        const updated = pre_updated.filter((value, index, array) => array.indexOf(value) === index);
                            // Внесение новых параметров в базу
                        await db('events_req_form').where('name', obj_req.name).update({
                            lesson: obj_req.lesson,
                            breaktime: obj_req.breaktime,
                            lunch: obj_req.lunch,
                            inProcessing: false,
                            date: obj_req.date,
                            isAccepted: true
                        });
                            // Создание новой резервной копии для каждого нового шаблона в запросе
                        let isNew = true;
                        for (let i in updated) {
                            for (let j in example) {
                                if (updated[i] === example[j]) 
                                    isNew = false;
                            }

                            if (isNew) {
                                    // Необходима новая резервная копия
                                const template = await db('tmp').select('*').where('name', updated[i]);
                                const eventsTemp = await db('events_tmp').select('*').where('tmpid', template[0].id);    
                                delete template[0].id;
                                template[0].from = request[0].id;
                                const newTmp = await db('tmp_acc').insert(template[0]).returning("*");

                                for (let i in eventsTemp) {
                                    delete eventsTemp[i].id;
                                    eventsTemp[i].tmpid = newTmp[0].id;
                                    await db('events_tmp_acc').insert(eventsTemp[i]);
                                }  
                            }
                            if (obj_req.isspecial)
                                break;
                            isNew = true;
                        }
                            // Вычищение неиспользованных копий (либо уже узамененные шаблоны)
                        let newerUsed = true;
                        for (let i in example) {
                            for (let j in updated) {
                                if (updated[j] === example[i])
                                    newerUsed = false;
                            }
                            if (newerUsed) {
                                const last = await db('tmp_acc').select('*').where('name', example[i]).where('from', request[0].id);
                                await db('events_tmp_acc').where('tmpid', last[0].id).del();
                                await db('tmp_acc').where('name', example[i]).where('from', request[0].id).del();
                            }
                            if (obj_req.isspecial)
                                break;
                            newerUsed = true;
                        }
                            // Если прилетают детальные изменения (для Утверждения или Применения изменений)
                        if (has_changes !== undefined) {
                            const last = await db('tmp_acc').select('*').where('name', obj_req.lesson).where('from', request[0].id);
                            await db('events_tmp_acc').where('tmpid', last[0].id).del();
                            for (let i in upd_less) {
                                delete upd_less[i].id;
                                upd_less[i].order = i + 1;
                                upd_less[i].tmpid = last[0].id;
                                await db('events_tmp_acc').insert(upd_less[i]);
                            }

                            if (!obj_req.isspecial) {
                                const lasty = await db('tmp_acc').select('*').where('name', obj_req.breaktime).where('from', request[0].id);
                                await db('events_tmp_acc').where('tmpid', lasty[0].id).del();
                                for (let i in upd_break) {
                                    delete upd_break[i].id;
                                    upd_break[i].order = i + 1;
                                    upd_break[i].tmpid = lasty[0].id;
                                    await db('events_tmp_acc').insert(upd_break[i]);
                                }

                                const lastyk = await db('tmp_acc').select('*').where('name', obj_req.lunch).where('from', request[0].id);
                                await db('events_tmp_acc').where('tmpid', lastyk[0].id).del();
                                for (let i in upd_lunch) {
                                    delete upd_lunch[i].id;
                                    upd_lunch[i].order = i + 1;
                                    upd_lunch[i].tmpid = lastyk[0].id;
                                    await db('events_tmp_acc').insert(upd_lunch[i]);
                                }
                            }
                        }
                            // Если редактируется активное отображение, то при необходимости вносим изменения сразу на транслсяцию
                        if (request[0].isActive) {
                            if (request[0].isspecial) {
                                const prog = await db('tmp_acc').select('*').where('name', request[0].lesson).where('from', request[0].id);
                                const events = await db('events_tmp_acc').select('*').where('tmpid', prog[0].id).orderBy('order');
                                for (let i in events) {
                                    delete events[i].id;
                                    delete events[i].tmpid;
                                    await db('events').insert( events[i] );
                                }
                            } else {
                                const Lessons = [ 
                                    [30000, 31200, 'Перерыв'], // Перерыв, с 8:20
                                    [31200, 36900, 'Пара'], // 1ая пара, с 8:40
                                    [36900, 37500, 'Перерыв'], // Перерыв, с 10:15
                                    [37500, 43200, 'Пара'], // 2ая пара, с 10:25
                                    [43200, 46200, 'Обед'], // Обед, С 12:00
                                    [46200, 51900, 'Пара'], // 3ая пара, с 12:50
                                    [51900, 52500, 'Перерыв'], // Перерыв, с 14:25
                                    [52500, 58200, 'Пара'], // 4ая параб с 14:35
                                    [58200, 58800, 'Перерыв'], // Перерыв, с 16:10
                                    [58800, 64500, 'Пара'], // 5ая пара, с 16:20
                                ];
                            
                                function getState(curSec) {
                                    for (let i in Lessons)
                                        if (curSec >= Lessons[i][0] && curSec < Lessons[i][1]) 
                                            return Lessons[i][2];
                                        // После 17:55 и до 8:20 - Свободное время
                                    return 'Свободка'; // Играет шаблон "Обед"
                                }

                                function WhatTime() {                                           // Узнать время в секундах с начала дня
                                    let today = new Date();                                       // Получить текущее время и вернуть значение в секнудах
                                    return  (today.getHours() * 60 + today.getMinutes()) * 60 + today.getSeconds();
                                }

                                switch (getState(WhatTime())) {
                                    case 'Перерыв':
                                        const prog_br = await db('tmp_acc').select('*').where('name', request[0].breaktime).where('from', request[0].id);
                                        const events_br = await db('events_tmp_acc').select('*').where('tmpid', prog_br[0].id).orderBy('order');
                                        for (let i in events_br) {
                                            delete events_br[i].id;
                                            delete events_br[i].tmpid;
                                            await db('events').insert( events_br[i] );
                                        }
                                        break;
                                    case 'Пара':
                                        const prog_le = await db('tmp_acc').select('*').where('name', request[0].lesson).where('from', request[0].id);
                                        const events_le = await db('events_tmp_acc').select('*').where('tmpid', prog_le[0].id).orderBy('order');
                                        for (let i in events_le) {
                                            delete events_le[i].id;
                                            delete events_le[i].tmpid;
                                            await db('events').insert( events_le[i] );
                                        }
                                        break;
                                    case 'Обед':
                                    default:
                                        const prog_lu = await db('tmp_acc').select('*').where('name', request[0].lesson).where('from', request[0].id);
                                        const events_lu = await db('events_tmp_acc').select('*').where('tmpid', prog_lu[0].id).orderBy('order');
                                        for (let i in events_lu) {
                                            delete events_lu[i].id;
                                            delete events_lu[i].tmpid;
                                            await db('events').insert( events_lu[i] );
                                        }
                                } 
                            }

                        }
                            // Поимка "Утверждения" - оповещение автора об утверждении шаблона
                        if (!request[0].isAccepted) {
                            const callback = 'Модератор "' + req.session.username + '" утвердил ваш запрос "' + request[0].name + '". \nКомментарий модератора: ' + comment;

                            let date_ob = new Date();
                            let dd = ("0" + date_ob.getDate()).slice(-2);
                            let mm = ("0" + (date_ob.getMonth() + 1)).slice(-2);
                            let yyyy = date_ob.getFullYear();

                            let date;
                            if (((Number(mm) % 2 === 1 && Number(mm) <= 7) || (Number(mm) > 7 && Number(mm) % 2 === 0)) && Number(dd) > 28) {
                                if (Number(mm) + 1 < 10)
                                    date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (31 - Number(dd)));
                                else
                                    date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (31 - Number(dd)));
                            } else if ((Number(mm) === 4 || Number(mm) === 6 || Number(mm) === 9 || Number(mm) === 11) && Number(dd) > 27) {
                                if (Number(mm) + 1 < 10)
                                    date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (30 - Number(dd)));
                                else
                                    date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (30 - Number(dd)));
                            } else if (Number(mm) === 2 && Number(dd) > 25) {
                                if (Number(mm) + 1 < 10)
                                    date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (28 - Number(dd)));
                                else
                                    date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (28 - Number(dd)));
                            } else {
                                if (Number(dd) + 3 < 10)
                                    date = yyyy + '-' + mm + '-0' + (Number(dd) + 3);
                                else
                                    date = yyyy + '-' + mm + '-' + (Number(dd) + 3);
                            }

                            // Оповестить автора запроса об отклонении
                            await db('ads').insert({
                                name: "Запрос утвержден",
                                comment: callback,
                                timeOfLife: date,
                                author: "System",
                                translate: "false",
                                personal: request[0].author
                            });
                        }
                        res.status(200).json({message: 'Запрос успешно утвержден.'});
                    }
                } else {
                    res.status(400).json({message: 'Некорректный параметр. Скорее всего, вы сделали это намеренно. Сообщаем администратору.'});
                }
            } else {
                res.status(400).json({ message: 'errdate' });
            }
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
        }
        
        res.end();
    }
        // Отклонить
    async Deny(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const { name, comment } = req.body;

            if (name) {
                const request = await db('events_req_form').select('id', 'name','whoAccept', 'isAccepted', 'inProcessing', 'lesson', 'breaktime', 'lunch', 'author').where({ name });
                if (request !== undefined && request[0].inProcessing && request[0].whoAccept === req.session.username) {
                    const ids = await db('tmp_acc').select('*').where('from', request[0].id);
                    for (let i in ids) {
                        try {
                            await db('events_tmp_acc').where('tmpid', ids[i].id).del();
                            await db('tmp_acc').where('id', ids[i].id).del();
                        } catch (e) {
                            console.error(e);
                        }
                    }
                    await db('events_req_form').select('*').where({ name }).del();

                    if (!request[0].isAccepted) {
                        const callback = 'Модератор "' + req.session.username + '" отклонил ваш запрос "' + request[0].name + '". \nКомментарий модератора: ' + comment;

                        let date_ob = new Date();
                        let dd = ("0" + date_ob.getDate()).slice(-2);
                        let mm = ("0" + (date_ob.getMonth() + 1)).slice(-2);
                        let yyyy = date_ob.getFullYear();

                        let date;

                        if (((Number(mm) % 2 === 1 && Number(mm) <= 7) || (Number(mm) > 7 && Number(mm) % 2 === 0)) && Number(dd) > 28) {
                            if (Number(mm) + 1 < 10)
                                date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (31 - Number(dd)));
                            else
                                date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (31 - Number(dd)));
                        } else if ((Number(mm) === 4 || Number(mm) === 6 || Number(mm) === 9 || Number(mm) === 11) && Number(dd) > 27) {
                            if (Number(mm) + 1 < 10)
                                date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (30 - Number(dd)));
                            else
                                date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (30 - Number(dd)));
                        } else if (Number(mm) === 2 && Number(dd) > 25) {
                            if (Number(mm) + 1 < 10)
                                date = yyyy + '-0' + (Number(mm) + 1) + '-0' + (3 - (28 - Number(dd)));
                            else
                                date = yyyy + '-' + (Number(mm) + 1) + '-0' + (3 - (28 - Number(dd)));
                        } else {
                            if (Number(dd) + 3 < 10)
                                date = yyyy + '-' + mm + '-0' + (Number(dd) + 3);
                            else
                                date = yyyy + '-' + mm + '-' + (Number(dd) + 3);
                        }

                            // Оповестить автора запроса об отклонении (если запрос отклоняется)
                        await db('ads').insert({
                            name: "Запрос отклонён",
                            comment: callback,
                            timeOfLife: date,
                            author: "System",
                            translate: "false",
                            personal: request[0].author
                        });
                    }
                }
            } else {
                    // Логировать админу о хакерской атаке
            }
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
        }
        
        res.end();
    }
        // Подробный просмотр шаблонов
    async Details(req, res) {
        if (req.session.role === 'admin' || req.session.role === 'moder') {
            const { obj } = req.body;
            let name = obj.name;

            const _req = await db('events_req_form').select('*').where({ name });

            if (obj.isspecial) {
                    // ЗАПРОС ПО СПЕЦ ШАБЛОНУ
                let copy_tmp, events;

                if (obj.lesson === _req[0].lesson) {
                        // Отправленный редактором
                    copy_tmp = await db('tmp_acc').where('from', _req[0].id).select('*');
                    events =  await db('events_tmp_acc').where('tmpid', copy_tmp[0].id).select('*');
                } else {
                        // Выбранный модератором
                    copy_tmp = await db('tmp').where('name', obj.lesson).select('*');
                    events =  await db('events_tmp').where('tmpid', copy_tmp[0].id).select('*');
                }
                res.json({
                    type: obj.isspecial,
                    data: {
                        lesson:     events,
                        breaktime:  '-',
                        lunch:      '-'
                    }
                });

            } else {
                    // ЗАПРОС ПО СТАНДАРТНОМУ ШАБЛОНУ
                let copy_tmp_lunch,
                    copy_tmp_lesson,
                    copy_tmp_breaktime,
                    events_lesson = '-',
                    events_breaktime = '-',
                    events_lunch = '-';

                    // Находится ли шаблон, который хочет просмотреть модератор, в резервной копии?
                const example = [_req[0].lesson, _req[0].breaktime, _req[0].lunch];
                let less_reserve = false, break_reserve = false, lunch_reserve = false;

                for (let i in example) {
                    if (example[i] === obj.lesson) {
                        less_reserve = true;
                    } else if (example[i] === obj.breaktime) {
                        break_reserve = true;
                    } else if (example[i] === obj.lunch) {
                        lunch_reserve = true;
                    }
                }

                if (obj.lesson !== '-') {
                    if (less_reserve) {
                            // Отправленный редактором
                        copy_tmp_lesson = await db('tmp_acc').where('from', _req[0].id).where('name', obj.lesson).select('*');
                        events_lesson = await db('events_tmp_acc').where('tmpid', copy_tmp_lesson[0].id).select('*').orderBy('order');
                    } else {
                            // Выбранный модератором
                        copy_tmp_lesson = await db('tmp').where('name', obj.lesson).select('*');
                        events_lesson = await db('events_tmp').where('tmpid', copy_tmp_lesson[0].id).select('*').orderBy('order');
                    }
                }

                if (obj.breaktime !== '-') {
                    if (break_reserve) {
                            // Отправленный редактором
                        copy_tmp_breaktime = await db('tmp_acc').where('from', _req[0].id).where('name', obj.breaktime).select('*');
                        events_breaktime = await db('events_tmp_acc').where('tmpid', copy_tmp_breaktime[0].id).select('*');
                    } else {
                        // Выбранный модератором
                        copy_tmp_breaktime = await db('tmp').where('name', obj.breaktime).select('*');
                        events_breaktime = await db('events_tmp').where('tmpid', copy_tmp_breaktime[0].id).select('*');
                    }
                }

                if (obj.lunch !== '-') {
                    if (lunch_reserve) {
                            // Отправленный редактором
                        copy_tmp_lunch = await db('tmp_acc').where('from', _req[0].id).where('name', obj.lunch).select('*');
                        events_lunch = await db('events_tmp_acc').where('tmpid', copy_tmp_lunch[0].id).select('*');
                    } else {
                        // Выбранный модератором
                        copy_tmp_lunch = await db('tmp').where('name', obj.lunch).select('*');
                        events_lunch = await db('events_tmp').where('tmpid', copy_tmp_lunch[0].id).select('*');
                    }
                }

                res.json({
                    type: obj.isspecial,
                    data: {
                        lesson:     events_lesson,
                        breaktime:  events_breaktime,
                        lunch:      events_lunch
                    }
                });
            }
        } else {
            const title = "Error";
            res.status(404).render(createPath('error'), { title });
        }

        res.end();
    }
        // Завершение процесса обработки (автоматический вызов)
    async EndProcess(req, res) {
        const { name } = req?.body;
        const db_user = await db('ec_user').select('*').where({ name });
        if (db_user[0].name) {
            await db('events_req_form').where('whoAccept', name).where('inProcessing', true).update({
                inProcessing: false
            });
        }

        res.end();
    }
}

module.exports = new ModerController() 