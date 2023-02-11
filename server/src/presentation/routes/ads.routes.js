const Router = require('express')
const router = new Router()
const AdsController = require('../controller/ads.controller')

const path = require('path');
const express = require("express");

router.use(express.json());
router.use(express.urlencoded({ extended: true })); // Парсинг страницы
    // Разрешение к использованию директории для хранения общих файлов
router.use(express.static(path.join(__dirname, '../public')));

    // Интерфейс уведомителя
router.get('/public', AdsController.getAdsTranslate); 
router.get('/', AdsController.getAds);                  // Чтение всех уведомлений       
router.post('/', AdsController.addAds);                 
router.post('/del', AdsController.deleteAds);  


module.exports = router