module.exports = class evtLog {

    constructor(type, e_name_start, e_name_end, src_type_start, src_type_end, timing_start, timing_end, src_start, src_end, date, time) {

        this.type = type;           // Type - тип записи (1: add, 2: upd, 0: delete)

        this.e_name_start = e_name_start; // Имя события, для которого существует запись лога
        this.e_name_end = e_name_end;     // Для ADD и DEL - нач и кон совпадают для UPD - соответствуют

        this.src_type_start = src_type_start;   // Тип логгируемого события 
        this.src_type_end = src_type_end;     // Для ADD и DEL - нач и кон совпадают для UPD - соответствуют

        this.src_start = src_start;     // Ссылка на ресурс
        this.src_end= src_end;          // Для ADD и DEL - нач и кон совпадают для UPD - соответствуют
                                         
        this.timing_start = timing_start;   // Тайминг (время воспроизведения события на трансляции)
        this.timing_end = timing_end;       // Для ADD и DEL - нач и кон совпадают для UPD - соответствуют
        
        this.date = date;           // Дата формирования лога
        this.time = time;           // Время формирования лога
    }
}