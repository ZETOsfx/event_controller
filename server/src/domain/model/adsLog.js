module.exports = class adsLog {

    constructor(type, date, time, u_name, author, e_name, comment, translate, timeout, isauto) {

        this.type = type;           // Type - тип записи (1: add / 0: del) 

        this.u_name = u_name;       // Имя профиля, чье действие логгируется

        this.author = author;       // Автор объявления, дествие над которым логгируется

        this.e_name = e_name;       // Заголовок объявления
        this.comment = comment;     // Текст объявления 
        this.translate = translate; // Вывод объявления на экран (0: нет; 1: да)
        this.timeout = timeout;     // Время, до которого актуально событие

        this.date = date;           // Дата формирования лога
        this.time = time;           // Время формирования лога

        this.isauto = isauto;       // Факт удаления - истечение срока актуальности? (0: нет; 1 - да)   
    }
}