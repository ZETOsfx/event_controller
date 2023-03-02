const Router = require('express');
const router = new Router();
const ModerController = require('../controller/moder.controller');

const express = require("express");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

    // Загрузка страницы
router.get('/', ModerController.onLoad);
    // Получение списка запросов на утверждение
router.get('/requests', ModerController.getRequests);
    // Список всех шаблонов, которые может задействовать модератор для редактирования запросов
router.patch('/alltmp', ModerController.getTemplates);
    // Переключить процесс
router.patch('/switchprocess', ModerController.switchProcess);
    // Утвердить запрос 
router.patch('/access', ModerController.Access);
    // Отклонить запрос 
router.put('/deny', ModerController.Deny);
    // Открыть выбранный в поле шаблон
router.patch('/details', ModerController.Details);
    // Сохранить изменения в шаблоне
router.put('/save', ModerController.SaveTemp);

router.put('/endprocess', ModerController.EndProcess);

module.exports = router;
