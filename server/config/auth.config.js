require('dotenv').config();

module.exports = {
    accessToken: {
        secret: process.env.SECRET,
        expired: "1min",
        type: "access",
    },
    refreshToken: {
        secret: process.env.SECRET,
        expired: "3min",
        type: "refresh",
    },
}