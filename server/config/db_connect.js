require('dotenv').config();
const knex = require('knex') ({
    client: 'pg',
    connection: {
      host : 'localhost',
      port : 5432,
      user : process.env.DB_USER,
      password : process.env.DB_PASSWORD,
      database : process.env.MAIN_DB
    }
  });
module.exports = knex;