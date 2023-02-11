const UsersUseCase = require("../../domain/use-cases/user.use-case");

exports.addUser = async (req, res) => {
    try {
        const usersUseCase = new UsersUseCase();
        const data = req.body;

        if (data) {
            const user = await usersUseCase.addOne(data);

            return res.status(200).send(user);
        }
    } catch (err) {
        return res.send(err);
    }
};

exports.getUser = async (req, res) => {
    try {
        const usersUseCase = new UsersUseCase();

        if (req?.query?.name) {
            const name = req.query.name;

            const user = await usersUseCase.getOne(name);
            return res.status(200).send(user);
        }

        const users = await usersUseCase.getAll();

        return res.status(200).send(users);
    } catch (e) {
        return res.send(e);
    }
};

exports.updateUser = async (req, res) => {
    try {
        const usersUseCase = new UsersUseCase();
        const data = req.body;

        if (data?.role) {
            const user = await usersUseCase.updateOne(
                data.id,
                data.role
            );
            return res.status(200).send(user);
        }
    } catch (e) {
        return res.send(e);
    }
};