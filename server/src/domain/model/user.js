module.exports = class User {
    constructor(user) {
        this.user = {
            id: user.id,
            name: user.name,
            role: user.role,
            password: user.password
        };

        return this.user;
    }
}