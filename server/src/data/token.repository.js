const knex = require("../../config/db_connect");
const TOKENS_TABLE = "tokens";
const { DataBaseError, errors } = require("../utils/error.util");

module.exports = class TokensRepository {
    async getToken(userId) {
        try {
            const token = await knex(TOKENS_TABLE).select("*").where("user_id", userId);
            if (!token[0]) { return null; }

            return token[0];
        } catch (error) {
            throw new DataBaseError(error.get("DATA_BASE_ERROR"));
        }
    }

    async deleteToken(id) {
        try {
            const result = await knex(TOKENS_TABLE).del().where("id", id).returning("id");
            if (!result[0]) {
                throw new DataBaseError(errors.get("DATA_BASE_ERROR"));
            }
            return { id: result[0], };
        } catch (error) {
            throw error;
        }
    }

    async addToken(userId, refreshToken, role) {
        try {
            const result = await knex(TOKENS_TABLE).insert({
                user_id: userId,
                role: role,
                token: refreshToken
            }).returning("*");
            return result;
        } catch (error) {
            throw new DataBaseError(errors.get("DATA_BASE_ERROR"));
        }
    }

    async updateToken(id, userId, refreshToken, role) {
        try {
            const result = await knex(TOKENS_TABLE).where("id", id).update({
                user_id: userId,
                role: role,
                token: refreshToken
            }).returning("*");
            if (!result[0].id) {
                throw new DataBaseError(errors.get("DATA_BASE_ERROR"));
            }
            return result[0];
        } catch (error) {
            console.error(error);
            throw new DataBaseError(errors.get("DATA_BASE_ERROR"));
        }
    }
};