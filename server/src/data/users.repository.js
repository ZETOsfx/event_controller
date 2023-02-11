const knex = require("../../config/db_connect");
const { DataBaseError, errors } = require("../utils/error.util");

module.exports = class UsersRepository {
    async addUser(name, role, hashedPassword) {     // { name, role, passhash }
        try {
            const result = await knex("ec_user").insert({ 
                name: name,
                role: role,
                passhash: hashedPassword
            }).returning("*");

            if (!result[0]) 
                return null; 
            return result[0];

        } catch (error) {
            throw new DataBaseError(errors.get("DATA_BASE_ERROR"));
        }
    }

    async getAllUsers() {
        try {
            const users = await knex("ec_user").select('*');
            return users;
        } catch (err) {
            throw err;
        }
    }

    async getOneUser(name) {
        try {
            const user = await knex("ec_user").select("*").where("name", name);
            if (!user[0]) { return null; }

            return puser; 
        } catch (err) {
            throw err;
        }
    }

    async updateOneUser(id, role) {
        try {
            const user = await knex("ec_user").where("id", id).update({ role: role }, ["id", "name", "role"]);
            return user;
        } catch (err) {
            throw err;
        }
    }
};