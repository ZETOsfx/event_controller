const usersRoutesInit = require("./users.routes");
const authRouteInit = require("./auth.routes");

const routeInit = (app, express) => {
    app.use(express.urlencoded({ extended: true }));
    app.use(express.json());
    app.use(function (req, res, next) {
        res.header(
            "Access-Control-Allow-Headers",
            "x-access-token, Origin, Content-Type, Accept"
        );
        next();
    });
    
    usersRoutesInit(app);
    authRouteInit(app);
};

module.exports = {
    routeInit
};