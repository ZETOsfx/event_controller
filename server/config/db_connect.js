const knex = require('knex') ({
    client: 'pg',
    connection: {
      host : 'localhost',
      port : 5432,
      user : 'admin',
      password : 'root',
      database : 'db_user'
    }
  });
module.exports = knex;