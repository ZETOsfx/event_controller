const knex = require('knex') ({
    client: 'pg',
    connection: {
      host : 'localhost',
      port : 5432,
      user : 'alexander_perelight',
      password : 'ass_my_pass',
      database : 'ecdb'
    }
  });
module.exports = knex;