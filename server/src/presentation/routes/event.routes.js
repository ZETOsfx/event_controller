const Router = require('express');
const router = new Router();
const EventController = require('../controller/event.controller');

const express = require("express");

    // Разрешение к использованию директории для хранения общих файлов + парсинг страницы
router.use(express.json());
router.use(express.urlencoded({ extended: true }));

    // Загрузка страницы (на которую будет подставлен интерфейс)
router.get('/', EventController.getEvents);
    // Получение списка шаблонов
router.get('/alltmp', EventController.allTemplates); 
    // Открытие шаблона
router.patch('/all', EventController.getTemplate);          
    // Сохранение шаблона
router.patch('/save', EventController.saveTemplate);       
    // Создать новый шаблон
router.put('/addtmp', EventController.createTemplate);
    // Удалить шаблон
router.delete('/deltmp', EventController.deleteTemplate);
    // Отправить группу шаблонов на модерацию
router.put('/send', EventController.sendTemplate);


// Выдача списка событий на трансляцию
router.get('/json', EventController.getEventsFormatJSON);
    // Чтение логов
router.get('/logview', EventController.logRead);


module.exports = router;