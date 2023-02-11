const usersController = require("../controller/users.controller");
const authJwt = require("../middleware/auth-jwt.middleware");

module.exports = function (app) {
    app.get("/api/students/", [authJwt.verifyToken, authJwt.isRole], usersController.getUser);
    app.patch("/api/students/", [authJwt.verifyToken, authJwt.isRole], usersController.updateUser);
    app.post("/api/students/", [authJwt.verifyToken, authJwt.isRole], usersController.addUser);
};