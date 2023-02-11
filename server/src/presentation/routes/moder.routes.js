const Router = require('express');
const router = new Router();
const ModerController = require('../controller/moder.controller');

const path = require('path');
const express = require("express");

router.use(express.json());
router.use(express.urlencoded({ extended: true })); // Парсинг страницы
    // Разрешение к использованию директории для хранения общих файлов
router.use(express.static(path.join(__dirname, '../public')));


router.get('/requests', ModerController.getRequests)

// + templates


module.exports = router