var mysql = require("mysql");
var util = require("util");

var pool = mysql.createPool({
  connectionLimit: 10,
  host: "remotemysql.com",
  user: "j9F2UwWZ9s",
  password: "zvgNXCriJI",
  database: "j9F2UwWZ9s",
  port: 3306,
});

pool.query = util.promisify(pool.query);

module.exports = pool;
