const Router = require('express');
const router = new Router();
const ApiController = require('../controller/api.controller');

const express = require("express");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

// // Выдача списка событий на трансляцию
// router.get('/json', ApiController.getEventsFormatJSON);

module.exports = router;