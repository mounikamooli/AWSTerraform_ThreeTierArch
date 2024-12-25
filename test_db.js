const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'your-db-instance.xxxxxx.us-east-1.rds.amazonaws.com',
  user: 'your-username',
  password: 'your-password',
  database: 'your-database',
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
    return;
  }
  console.log('Connected to the MySQL database!');
  connection.end(); // Close the connection after testing
});
