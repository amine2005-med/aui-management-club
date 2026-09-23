// Quick test script to check server configuration
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, 'server', '.env') });

console.log('=== Server Configuration Check ===\n');
console.log('Environment Variables:');
console.log(`  DB_HOST: ${process.env.DB_HOST || 'localhost (default)'}`);
console.log(`  DB_USER: ${process.env.DB_USER || 'root (default)'}`);
console.log(`  DB_PASSWORD: ${process.env.DB_PASSWORD ? '***' : '(empty - this might be the problem!)'}`);
console.log(`  DB_NAME: ${process.env.DB_NAME || 'aui_clubs (default)'}`);
console.log(`  PORT: ${process.env.PORT || '5001 (default)'}`);

console.log('\n=== Checking .env file ===');
const fs = require('fs');
const envPath = path.join(__dirname, 'server', '.env');
if (fs.existsSync(envPath)) {
  console.log('✓ .env file exists at:', envPath);
  const envContent = fs.readFileSync(envPath, 'utf8');
  if (envContent.includes('your_mysql_password') || envContent.includes('your_actual_mysql_password')) {
    console.log('⚠ WARNING: .env file still has placeholder password!');
    console.log('   Edit server/.env and set your real MySQL password.');
  }
} else {
  console.log('✗ .env file NOT found at:', envPath);
  console.log('   Create it by copying server/env.example to server/.env');
}

console.log('\n=== Testing MySQL Connection ===');
const mysql = require('mysql2/promise');

async function testConnection() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'aui_clubs',
    });
    
    await connection.ping();
    console.log('✓ MySQL connection successful!');
    await connection.end();
    return true;
  } catch (error) {
    console.log('✗ MySQL connection failed:');
    console.log('  Error:', error.message);
    
    if (error.code === 'ER_ACCESS_DENIED_ERROR') {
      console.log('\n  → Fix: Check your DB_PASSWORD in server/.env');
    } else if (error.code === 'ER_BAD_DB_ERROR') {
      console.log('\n  → Fix: Database does not exist. Run:');
      console.log('    mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql');
    } else if (error.code === 'ECONNREFUSED') {
      console.log('\n  → Fix: MySQL service is not running. Start MySQL service.');
    }
    return false;
  }
}

testConnection().then((success) => {
  if (success) {
    console.log('\n✓ All checks passed! You can start the server with:');
    console.log('  npm run dev:server');
  } else {
    console.log('\n✗ Please fix the issues above before starting the server.');
  }
  process.exit(success ? 0 : 1);
});

