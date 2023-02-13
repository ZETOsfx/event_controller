require('dotenv').config();

const PORT = process.env.PORT || 5000;

const express = require('express');
const session = require('express-session');
const favicon = require('serve-favicon');

const path = require('path');
const createPath = (page) => path.resolve(__dirname, 'src/presentation/views', `${page}.ejs`);

const db = require('./config/db_connect');    // Database connection

    // ROUTERS
const userRouter  = require('./src/presentation/routes/user.routes' );
const eventRouter = require('./src/presentation/routes/event.routes');
const adsRouter   = require( './src/presentation/routes/ads.routes' );
const moderRouter = require('./src/presentation/routes/moder.routes');

    // JWT auth
// const AuthRouter = require('./src/presentation/routes/index');

const cors = require('cors');
const morgan = require('morgan');

// ----- APPLICATION -----
    
const app = express();

app.set('view-engine', 'ejs');

app.listen(PORT, (error) => {
    error ? console.log(error) : console.log(`listening port ${PORT}`);
});
        // --- LOGGING ---
app.use(morgan(':method :url :status :res[content-length] - :response-time ms'));

app.use(express.urlencoded({ extended: false }));   // Parsing requests
    
const corsOptions = {
    origin:'http://localhost:3000', 
    credentials: true,            // access-control-allow-credentials:true
    optionSuccessStatus: 200
}
                                                         
app.use(cors(corsOptions));

app.use(express.json());

const oneDay = 1000 * 60 * 60 * 24;     // Удержание сессии

app.use(
    session({
        secret: 'alexander_perelight',
        saveUninitialized: true,
        cookie: { maxAge: oneDay, theme: "light" },
        resave: false,
    })
);

app.use(express.static(path.join(__dirname, 'public')));

app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

    // Библиотека VueJS
app.get('/js/vue.js', (req, res) => {
    res.header("Content-Type", "application/javascript; charset=UTF-8");
    res.sendFile(`${__dirname}/vue/dist/main.js`);
});

// AuthRouter.routeInit(app, express);  // JWT auth
app.use('/account', userRouter);
app.use('/event', eventRouter);
app.use('/ads', adsRouter);
app.use('/moder', moderRouter);

// ----- ОБЩИЕ СТРАНИЦЫ ------

app.get('/', (req, res) => {
    res.redirect('index');
});

app.get('/index', async (req, res) => {
    const title = "Home";
    ads = await db('ads').select('*').where('translate', 'true').orderBy('id');

    res.render(createPath('index'), { title, session: req.session, ads});
});

app.get('/guide', (req, res) => {
    const title = "Guide";
    res.render(createPath('guide'), { title, session: req.session });
});

// ----- NOT IMPLEMENT ROLES -----

app.get('/moder', (req, res) => {
    if (!(req.session.loggedin && (req.session.role === 'admin' || req.session.role === 'moder'))) {
        const title = "Error";
        res.status(404).render(createPath('error'), { title });
    }
    const title = "ModerPanel";
    res.render(createPath('moder'), { title, session: req.session });
});

// 404

app.use((req, res) => {
    const title = "Error";
    res
        .status(404)
        .render(createPath('error'), { title });
});