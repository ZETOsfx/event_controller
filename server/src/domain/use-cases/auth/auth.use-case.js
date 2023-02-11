const TokensRepository = require("../../../data/token.repository");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const config = require("../../../../config/auth.config");
const { TokensHelper, AccessToken, RefreshToken } = require("./tokens.helper");

const {
    UserNotFoundError,
    InvalidTokenError,
    ExpiredTokenError,
    BadRequestError,
    PropertyRequiredError,
    errors,
} = require("../../../utils/error.util");

const REFRESH_TYPE = "refresh";

module.exports = class AuthUseCase {
    useCase;
    tokensRepository;
    refreshToken;
    tokensHelper;

    constructor(useCase) {
        this.useCase = useCase;
        this.refreshToken = new RefreshToken();
        this.tokensRepository = new TokensRepository();

        const accessToken = new AccessToken();
        const tokensRepository = this.tokensRepository;
        const refreshToken = this.refreshToken;

        this.tokensHelper = new TokensHelper({
            tokensRepository,
            accessToken,
            refreshToken,
        });
    }

    async signIn(name, password) {
        try {
                // Начилие пользователя с данным Login'ом
            const user = await this.useCase.getOne(name);   // password : passhash

            if (!user) {    // Неверное имя пользователя!
                throw new UserNotFoundError(errors.get("USER_NOT_FOUND"));
            }
                // Проверка соответствия пароля
            const passwordIsValid = bcrypt.compareSync(
                String(password),
                String(user.passhash)
            );
                
            if (!passwordIsValid) { // Неверный пароль!
                throw new UserNotFoundError(errors.get("USER_NOT_FOUND"));
            }
                // Обновление токена по Refresh
            const tokens = await this.tokensHelper.updateTokens(user.role, user.id);
    
            return {
                tokens
            };
        } catch (error) {
            throw error;
        }      
    }

    async signUp(fields) {
        let { name, role, password } = fields;
    
        if (!password || !name || !role) {
            throw new PropertyRequiredError(errors.get("NO_PROPERTY"));
        };
    
        try {
            const hashedPassword = bcrypt.hashSync(String(password), 8);
        
            const message = await this.useCase.addOne(name, role, hashedPassword);
            return message;
        } catch (e) {
            throw e;
        }
      }

    async refreshTokens(refreshToken) {
        let userId;
        let tokenId;

        try {
            const payload = jwt.verify(refreshToken, config.refreshToken.secret);
            userId = payload.userId;
            tokenId = payload.id;
    
            if (payload.type !== REFRESH_TYPE) {
                throw new InvalidTokenError(errors.get("INVALID_TOKEN"));
            }
        } catch (e) {
            if (e instanceof jwt.TokenExpiredError) {
                throw new ExpiredTokenError(errors.get("EXPIRED_TOKEN"));
            }
    
            if (e instanceof jwt.JsonWebTokenError) {
                throw new InvalidTokenError(errors.get("INVALID_TOKEN"));
            }
    
            throw new BadRequestError(errors.get("BAD_REQ"));
        }

        try {
            const tokenData = await this.refreshToken.getToken({
                userId,
                tokensRepository: this.tokensRepository,
            });
    
            const dbRefreshToken = jwt.verify(
                tokenData.token,
                config.refreshToken.salt
            );
    
            if (!tokenData) {
                throw new BadRequestError(errors.get("BAD_REQ"));
            }
    
            if (dbRefreshToken.id !== tokenId) {
                throw new InvalidTokenError(errors.get("INVALID_TOKEN"));
            }
    
            const tokens = await this.tokensHelper.updateTokens({
                role: tokenData.role,
                userId: tokenData.user_id,
            });
    
            return {
                tokens,
            };
        } catch (error) {
            throw error;
        }    
    }
};