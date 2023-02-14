const Router = require('express');
const router = new Router();
const ModerController = require('../controller/moder.controller');

const express = require("express");

const path = require('path');
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

router.use(express.json());
router.use(express.urlencoded({ extended: true }));
router.use(express.static(path.join(__dirname, '../public')));

    // Загрузка страницы
router.get('/', (req, res) => {
    if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'moder'))) {
        const title = "Error";
        res.status(404).render(createPath('error'), { title });
        res.end();
    }
    const title = "ModerPanel";
    res.render(createPath('moder'), { title, session: req.session });
});

    // Получение списка запросов на утверждение
router.get('/requests', ModerController.getRequests);

// + templates


module.exports = router