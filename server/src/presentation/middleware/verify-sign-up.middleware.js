const { authStrategy, } = require("../../domain/use-cases/auth/auth-strategy");
const {
        RoleNotFoundError,
        UserExistsError,
        PropertyRequiredError,
        errors,
    } = require("../../utils/error.util");
    
checkRolesExisted = async (req, res, next) => {
    const role = req.body.role;

    if (!role) {
        return res.send(new RoleNotFoundError(errors.get("ROLE_NOT_FOUND")));
    }

    if (!authStrategy[role]) {
        return res.send(new RoleNotFoundError(errors.get("ROLE_NOT_FOUND")));
    }

    next();
};

checkDuplicateName = async (req, res, next) => {
    if (!req.body) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    const name = req.body.name;
    const role = req.body.role;

    if (!name) {
        return res.send(new PropertyRequiredError(errors.get("NO_PROPERTY")));
    }

    const userUseCase = new authStrategy[role]();
    const user = await userUseCase.getOne(name);

    if (user) {
        return res.send(new UserExistsError(errors.get("USER_EXISTS")));
    }

    next();
};

const verifySignUp = {
    checkDuplicateName,
    checkRolesExisted,
};
  
module.exports = verifySignUp;
  