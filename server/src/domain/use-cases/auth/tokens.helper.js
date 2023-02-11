const jwt = require("jsonwebtoken");
const config = require("../../../../config/auth.config");
const { v4: uuidv4 } = require("uuid");
const { InvalidTokenError, errors } = require("../../../utils/error.util");

class TokensHelper {
    tokensRepository;

    constructor(payload) {
        const { tokensRepository, accessToken, refreshToken } = payload;

        this.tokensRepository = tokensRepository;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }

    async updateTokens(role, userId) {
        const accessToken = this.accessToken.generateToken(userId, role);
        const refreshToken = this.refreshToken.generateToken(userId);

        try {
            await this.replaceDbRefreshToken(userId, refreshToken, role);
    
            return {
                accessToken,
                refreshToken
            };
        } catch (error) {
            throw error;
        }    
    }

    async replaceDbRefreshToken(userId, refreshToken, role) {
        try {
            const token = await this.tokensRepository.getToken(userId);
                // Внесение нового токена в случае "смерти" старого
            if (!token) {
                await this.tokensRepository.addToken(userId, refreshToken, role);
            }
                // Обновление данных по refresh-токену (на выходе новая пара refresh-access)
            if (token) {
                await this.tokensRepository.updateToken(token.id, userId, refreshToken, role);
            }
        } catch (error) {
            throw error;
        }    
    }
}

class Token {
    createJwtToken(expiredTime, signature, secret) {
        return jwt.sign(signature, secret, {
            expiresIn: expiredTime,
        });
    }    
}

class AccessToken extends Token {
    constructor() {
        super();
    }

    generateToken(userId, role) {
        const jwtSinatureAccess = {
            id: userId,
            role,
            type: config.accessToken.type,
        };

        return this.createJwtToken(
            config.accessToken.expired,
            jwtSinatureAccess,
            config.accessToken.secret
        );
    }
}

class RefreshToken extends Token {
    token;

    constructor() {
        super();
    }

    generateToken(userId) {
        const jwtSignatureRefresh = {
            type: config.refreshToken.type,
            userId,
            id: uuidv4(),
        };

        const refreshToken = this.createJwtToken(
            config.refreshToken.expired,
            jwtSignatureRefresh,
            config.refreshToken.secret
        );

        this.token = refreshToken;

        return refreshToken;
    }

    async getToken(userId, tokensRepository) {
        try {
            const token = await tokensRepository.getToken(userId);
        
            if (!token) {
                throw new InvalidTokenError(errors.get("INVALID_TOKEN"));
            }

            return token;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = {
    TokensHelper,
    RefreshToken,
    AccessToken,
};