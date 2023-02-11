const UsersUseCase = require("../user.use-case");

const authStrategy = {
    // admin:    UsersUseCase,  // Админа пока не можем регистрировать :D
    moder:    UsersUseCase,
    adsender: UsersUseCase,
    editor:   UsersUseCase,
};

module.exports = {
    authStrategy,
};