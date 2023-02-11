const  evtLog  = require('./evtLog'),
       adsLog  = require('./adsLog');

const db = require('../../../config/db_connect');    // Database connection

// Универсальный логгер для ведения журнала работы с событиями и объявлениями

class MainLogger {

    constructor() {
        this.eventLogging = [];     // Логгирование работы редактора
        this.adsLogging = [];       // Логгирование действий над объявлениями
    }

    pushEventLog(type, e_name_start, e_name_end, src_type_start, src_type_end, timing_start, timing_end, src_start, src_end, date, time) {  
            // Метод логгирования действий с шаблоном трансляции
        const logObj = new evtLog(type, e_name_start, e_name_end, src_type_start, src_type_end, timing_start, timing_end, src_start, src_end, date, time);
        this.eventLogging.push(logObj);
    }

    pushAdsLog(type, date, time, u_name, author, e_name, comment, translate, timeout, isauto = 0) {  
            // Метод логгирования действий с объявлениями
        const logObj = new adsLog(type, date, time, u_name, author, e_name, comment, translate, timeout, isauto);
        console.log(logObj)
        this.adsLogging.push(logObj);
    }

    // Синхронизация логгера с базой данных:
    //   > badBoy - плохой человек;    
    //   > obj - с чем идет работa <event / ads>
    //   > type - чё делаем (0 - delete, 1 - add, 2 - update)   
    async syncLoggerWithDatabase(person, obj, onlyorder = false) { 

        // -------------------- В ЗАВИСИМОСТИ ОТ ОБЪЕКТА ЛОГГИОВАНИЯ! ----------------------

        if (obj === 'ads') {    // ЧО ОН СДЕЛАЛ?

            // Почти ничего
            for (var i in this.adsLogging) {
                await db('log').insert({
                    object:             obj,                        // NOT NULL
                    type:               this.adsLogging[i].type,             
                    username:           person,                     // NOT NULL
                    date:               this.adsLogging[i].date,    // NOT NULL
                    time:               this.adsLogging[i].time,    // NOT NULL
                    name:               this.adsLogging[i].e_name,
                    a_comment:          this.adsLogging[i].comment,
                    a_author:           this.adsLogging[i].author,
                    a_translate:        this.adsLogging[i].translate,
                    a_timeout:          this.adsLogging[i].timeout,
                    a_isauto:           this.adsLogging[i].isauto
                });
            }

        } else {
                // Порвал себе ASS
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
            let date = dd + '-' + mm + '-' + yyyy;
            let time = hour + ':' + min + ':' + sec;

                // Получение новой группы (не повторяющейся)
            var group;
            const groupMax = await db('log').select('*').where('object', 'event').orderBy('e_group', 'desc');
            try {
                group = groupMax[0].e_group + 1;
            } catch (batman_Sanya) {
                group = 1;
            }

                // Упрощение (взаимосокращение действий в формате цепочки) 
            // ... Оно будет потом

                // Головной элемент группы
            await db('log').insert({
                object:             obj,              // NOT NULL
                type:               3,                // Header element of group
                username:           person,           // NOT NULL
                date:               date,             // NOT NULL
                time:               time,             // NOT NULL
                e_group:            group
            });

            if (onlyorder) {
                    // Элемент исключительной смены очереди
                await db('log').insert({
                    object:             obj,              // NOT NULL
                    type:               4,                // Header element of group
                    username:           person,           // NOT NULL
                    date:               date,             // NOT NULL
                    time:               time,             // NOT NULL
                    e_group:            group
            });
            } else {
                    // Занесение в базу данных  
                for (var i in this.eventLogging) {
                        // Сортировка внутри блоков по времени изменения
                    await db('log').insert({
                        object:             obj,                        // NOT NULL
                        type:               this.eventLogging[i].type,             
                        username:           person,                     // NOT NULL
                        date:               this.eventLogging[i].date,  // NOT NULL
                        time:               this.eventLogging[i].time,  // NOT NULL
                        e_group:            group,
                        name:               this.eventLogging[i].e_name_start,
                        e_name_e:           this.eventLogging[i].e_name_end,
                        e_src_type_s:       this.eventLogging[i].src_type_start,
                        e_src_type_e:       this.eventLogging[i].src_type_end,
                        e_src_s:            this.eventLogging[i].src_start,
                        e_src_e:            this.eventLogging[i].src_end,
                        e_timing_s:         this.eventLogging[i].timing_start,
                        e_timing_e:         this.eventLogging[i].timing_end
                    });
                }
            }
        }

        this.clearLogger();
    }
    
    clearLogger() {
        this.eventLogging = []; 
        this.adsLogging = []; 
    }

}

module.exports = new MainLogger();