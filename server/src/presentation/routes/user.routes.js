const Router = require('express')
const router = new Router()
const userController = require('../controller/user.controller')

const db = require('../../../config/db_connect');    // Database connection

const path = require('path');
const express = require("express");
const createPath = (page) => path.resolve(__dirname, '../views', `${page}.ejs`);

router.use(express.json());
router.use(express.urlencoded({ extended: true })); // Парсинг страницы

router.use(express.static(path.join(__dirname, '../public')));

// ------ ОБРАБОТКА ЗАПРОСОВ -----------
// ----------- REGISTER ----------------
router.get('/register', async (req, res) => {
    if (!(req.session.loggedin && (req.session.role === 'admin'))) {
        const title = "Error";
        res
            .status(404)
            .render(createPath('error'), { title });
    }
        // Список профилей (формат JSON)
    const users = await db('ec_user').select('*').orderBy([{ column: 'role', order: 'desc' }])

    const title = "Register";
    res.render(createPath('register'), { title, session: req.session, users });
});

router.post('/register', userController.registerAsync);


// ------------ LOGIN ------------------
router.get('/login', (req, res) => {
    const title = "Login";
    const message = 0;
    res.render(createPath('login'), { title, session: req.session, message });
});
router.post('/login', userController.signInAsync);
router.get('/logout', userController.logoutAsync);


router.get('/all', userController.getUsers);        //  /account/all   outbase { none }
router.post('/upd', userController.updateUser);     //  /account/upd    inbase  { id, name, role, password }
router.post('/rm', userController.deleteUser);    //  /account/rm     inbase  { id }

module.exports = router;