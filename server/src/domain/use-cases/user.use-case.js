const UsersRepository = require("../../data/users.repository");
const User = require("../model/user");
const UserHash = require("../model/userHash");
const { PropertyRequiredError, errors } = require("../../utils/error.util");
const HandlerUseCase = require("./common/handler.use-case");

module.exports = class UsersUseCase extends HandlerUseCase {
    constructor() {
        const mapFields = {
            id: "id",
            name: "name",
            role: "role",
            password: "password",
        };
        super(mapFields);
    }
        // Внести пользовательские данные в хранилище
    async addOne(name, role, hashedPassword) {
        
        if (!hashedPassword || !name || !role) {
            throw new PropertyRequiredError(errors.get("NO_PROPERTY"));
        };
            
        try {
            const usersRepository = new UsersRepository();
            const data = await usersRepository.addUser(name, role, hashedPassword);                                
        
            return new User(data);
        } catch (error) {
            throw error;
        }
    }
        // Получить данные всех пользователей сервера
    async getAll() {
        try {
            const usersRepository = new UsersRepository();
            const users = await usersRepository.getAllUsers();
            const mappedUsers = users.map((el) => el);

            return mappedUsers;
        } catch (error) {
            throw error;
        }
    }
        // Получить данные конкретного пользователя
    async getOne(name) {
        try {
            const userRepository = new UsersRepository();
            const usersData = await userRepository.getOneUser(name);    // passhash (hash) + password (hash)

            if (!usersData) {   
                return null;
            }
            
            return new UserHash(usersData);
        } catch (error) {
            throw error;
        }
    }
        // Обновить пользовательские данные 
    async updateOne(id, role) {
        try {
            const usersRepository = new UsersRepository();
            const user = await usersRepository.updateOneUser(id, role);
            return user;
        } catch (error) {
            throw error;
        }
    }
};