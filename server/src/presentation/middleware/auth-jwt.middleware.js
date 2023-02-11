const config = require("../../../config/auth.config");
const db = require('../../../config/db_connect');    // Database connection
const jwt = require("jsonwebtoken");
const {
    InvalidTokenError,
    ExpiredTokenError,
    TokenNotProvidedError,
    BadRequestError,
    AccessDeniedForRole,
    errors,
} = require("../../utils/error.util");

const verifyToken = (req, res, next) => {
    const authHeader = req.headers["authorization"];

    if (!authHeader) {
        return res.send(TokenNotProvidedError(errors.get("TOKEN_NOT_PROVIDED")));
    }

    const token = authHeader.replace("Bearer", "");

    try {
        const payload = jwt.verify(token, config.accessToken.salt);

        if (payload.type !== "access") {
            throw new InvalidTokenError(errors.get("INVALID_TOKEN"));
        }
    } catch (e) {
        if (e instanceof jwt.TokenExpiredError) {
            return res.send(new ExpiredTokenError(errors.get("EXPIRED_TOKEN")));
        }

        if (e instanceof jwt.JsonWebTokenError) {
            return res.send(new InvalidTokenError(errors.get("INVALID_TOKEN")));
        }

        return res.send(new BadRequestError(erros.get("BAD_REQ")));
    }

    next();
};

const isRole = async (req, res, next) => {
    const thereIsRole = await db("ec_role").select("id").where("role", req.body.role);
    
    if (!thereIsRole[0]) {
        return res.send(new AccessDeniedForRole(errors.get("ROLE_ACCESS_DENIED")));
    }

    next();
};

const authJwt = {
    verifyToken,
    isRole,
};

module.exports = authJwt;