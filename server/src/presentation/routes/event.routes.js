const Router = require('express')
const router = new Router()
const EventController = require('../controller/event.controller')

const path = require('path');
const express = require("express");

    // Разрешение к использованию директории для хранения общих файлов + парсинг страницы
router.use(express.json());
router.use(express.urlencoded({ extended: true })); 
router.use(express.static(path.join(__dirname, '../public')));

    // Загрузка страницы (на которую будет подставлен интерфейс)
router.get('/editor', EventController.getEvents);      
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
    

    // Чтение логов
router.get('/logview', EventController.logRead);
    // Выдача списка событий на трансляцию
router.get('/json', EventController.getEventsFormatJSON);


module.exports = router