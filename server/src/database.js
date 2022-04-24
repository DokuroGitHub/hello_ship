const pg = require('pg');

const { DATABASE, PG_USER, PASSWORD, HOST, PG_PORT } = process.env;

//const heroku_database_url = 'postgres://xjjopovytpesor:b3d7c9069d45a69611aa18f7a24aca73442ea83b085df3108c9278cd091725c8@ec2-52-5-110-35.compute-1.amazonaws.com:5432/d3q6q6ub5ajnj8?ssl=true';

const pgPool = new pg.Pool({
  database: DATABASE,
  user: PG_USER,
  password: PASSWORD,
  host: HOST,
  port: PG_PORT,
  //ssl: true
});

const getRoleByUserId = async (id) => {
  console.log(`getJsonRoleByUserId`);
  try {
    var query = `
SELECT * FROM private.get_role_by_user_id($1) as role;
`;
    var results = await pgPool.query(query, [id]);
    console.log(results?.rows);
    return results.rows[0];
  } catch (err) {
    console.log(err.toString());
    return null;
  }

  return pgPool
    .query(`SELECT * FROM private.get_role_by_user_id($1) as role;`, [id])
    .then((results) => {
      console.log(`succesfully`);
      return results.rows[0];
    });
};

const getPersonAccountById = async (id) => {
  console.log(`getPersonAccountById`);
  try {
    var results = await pgPool.query(
      `SELECT * FROM user_accounts WHERE username = $1`,
      [id]
    );
    //console.log(results.rows);
    return results.rows[0];
  } catch (err) {
    throw err;
  }
};

const getUsers2 = async (id) => {
  console.log(`getUsers2`);
  try {
    var query = `SELECT * FROM users ORDER BY id ASC;`;
    var results = await pgPool.query(query);
    console.log(results.rows);
    return results.rows;
  } catch (err) {
    console.log(err.toString());
    return null;
  }
};

const getOnlineUsers = async (id) => {
  console.log(`getOnlineUsers`);
  try {
    var query = `SELECT id, name, last_seen as "lastSeen" FROM online_users ORDER BY last_seen DESC;`;
    var results = await pgPool.query(query);
    return results.rows;
  } catch (err) {
    console.log(err.toString());
    return null;
  }
};

const getUsers = (request, response) => {
  pgPool.query(`SELECT * FROM users ORDER BY id ASC`, (error, results) => {
    if (error) {
      throw error;
    }
    response.status(200).json(results.rows);
  });
};

const getUserById = (request, response) => {
  const id = parseInt(request.params.id);

  pgPool.query(`SELECT * FROM users WHERE id = $1`, [id], (error, results) => {
    if (error) {
      throw error;
    }
    response.status(200).json(results.rows);
  });
};

const createUser = (request, response) => {
  const { name, email } = request.body;

  pgPool.query(
    `INSERT INTO users (name, email) VALUES ($1, $2)`,
    [name, email],
    (error, results) => {
      if (error) {
        throw error;
      }
      response.status(201).send(`User added with ID: ${result.insertId}`);
    }
  );
};

const updateUser = (request, response) => {
  const id = parseInt(request.params.id);
  const { name, email } = request.body;

  pgPool.query(
    `UPDATE users SET name = $1, email = $2 WHERE id = $3`,
    [name, email, id],
    (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).send(`User modified with ID: ${id}`);
    }
  );
};

const deleteUser = (request, response) => {
  const id = parseInt(request.params.id);

  pgPool.query(`DELETE FROM users WHERE id = $1`, [id], (error, results) => {
    if (error) {
      throw error;
    }
    response.status(200).send(`User deleted with ID: ${id}`);
  });
};

module.exports = {
  pgPool,
  getRoleByUserId,
  getPersonAccountById,
  getUsers,
  getUsers2,
  getOnlineUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
};
