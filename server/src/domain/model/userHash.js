module.exports = class UserHash {
    constructor(user) {
        this.user = {
            id: user.id,
            name: user.name,
            role: user.role,
            passhash: user.passhash
        };

        return this.user;
    }
}