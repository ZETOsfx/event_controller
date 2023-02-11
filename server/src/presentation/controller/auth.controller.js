const AuthUseCase = require("../../domain/use-cases/auth/auth.use-case");
const { authStrategy, } = require("../../domain/use-cases/auth/auth-strategy");
const { PropertyRequiredError, errors } = require("../../utils/error.util");


exports.signUp = async (req, res) => {  // Робит
    if (!req.body || !req.body.role) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    const role = req.body.role; 
    const fields = req.body;        // { "name": name, "role": role, "password": password }

    if (!authStrategy[role]) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    try {
        const userUseCase = new authStrategy[role]();
        const authUseCase = new AuthUseCase(userUseCase);
        const data = await authUseCase.signUp(fields);

        return res.status(200).send(data);
    } catch (e) {
        return res.status(400).send(e);
    }
};

exports.signIn = async (req, res) => {
    if (!req.body) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    const { name, password } = req.body;

    try {
        const userUseCase = new authStrategy["moder"]();
        const authUseCase = new AuthUseCase(userUseCase);
        const tokens = await authUseCase.signIn(name, password);

        return res.status(200).send(tokens);
    } catch (e) {
        return res.status(400).send(e);
    }
};

exports.refreshTokens = async (req, res) => {
    if (!req.body || !req.body.refreshToken) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    try {
        const authUseCase = new AuthUseCase();
        const tokens = await authUseCase.refreshTokens(req.body.refreshToken);

        return res.status(200).send(tokens);
    } catch (error) {
        return res.status(400).send(error);
    }
};
