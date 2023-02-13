const Router = require('express');
const router = new Router();
const ModerController = require('../controller/moder.controller');

const path = require('path');
const express = require("express");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));
router.use(express.static(path.join(__dirname, '../public')));

    // Загрузка страницы
router.get('/requests', ModerController.getRequests)
    // Получение списка 

// + templates


module.exports = router