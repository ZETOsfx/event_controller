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

            const date_check = await db('events_req_form').select('*').where('date', obj_req.date).where('isAccepted', true);

            if (date_check[0] === undefined) {
                if (obj_req.name) {
                    const request = await db('events_req_form').select('*').where('name', obj_req.name);
                    if (request !== undefined && request[0].inProcessing && !request[0].isAccepted && request[0].whoAccept === req.session.username) {
                        await db('events_req_form').where('name', obj_req.name).update({
                            inProcessing: false,
                            date: obj_req.date,
                            isAccepted: true
                        });
                    }

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

                    res.status(200).json({message: 'Запрос успешно утвержден.'});
                } else {
                    // СООБЩИТЬ АДМИНИСТРАТОРУ
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
                if (request !== undefined && request[0].inProcessing && !request[0].isAccepted && request[0].whoAccept === req.session.username) {
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


                    // Оповестить автора запроса об отклонении
                    await db('ads').insert({
                        name: "Запрос отклонён",
                        comment: callback,
                        timeOfLife: date,
                        author: "System",
                        translate: "false",
                        personal: request[0].author
                    });
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

    async EndProcess(req, res) {
        const { name } = req?.body;
        console.log(1 + name);

        const db_user = await db('ec_user').select('*').where({ name });

        if (db_user[0].name) {
            await db('events_req_form').where('whoAccept', name).where('inProcessing', true).update({
                inProcessing: false
            });
        }

        res.end();
    }
        // Сохранение изменений внутри открытого шаблона
    async SaveTemp(req, res) {
        const { spec, obj } = req.body;


        res.end();
    }

}

module.exports = new ModerController() 