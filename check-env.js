// Simple script to check .env file without requiring dotenv
const fs = require('fs');
const path = require('path');

console.log('=== Checking .env Configuration ===\n');

const envPath = path.join(__dirname, 'server', '.env');
const envExamplePath = path.join(__dirname, 'server', 'env.example');

if (!fs.existsSync(envPath)) {
  console.log('✗ .env file NOT found at:', envPath);
  console.log('\nCreating .env from env.example...');
  
  if (fs.existsSync(envExamplePath)) {
    fs.copyFileSync(envExamplePath, envPath);
    console.log('✓ Created .env file');
    console.log('\n⚠ IMPORTANT: Edit server/.env and set your MySQL password!');
  } else {
    console.log('✗ env.example also not found!');
    process.exit(1);
  }
} else {
  console.log('✓ .env file exists');
}

console.log('\n=== Reading .env file ===');
const envContent = fs.readFileSync(envPath, 'utf8');
const lines = envContent.split('\n');

let hasPassword = false;
let passwordIsPlaceholder = false;

lines.forEach(line => {
  const trimmed = line.trim();
  if (trimmed.startsWith('DB_PASSWORD=')) {
    hasPassword = true;
    const password = trimmed.split('=')[1];
    if (password && password !== '' && 
        !password.includes('your_mysql_password') && 
        !password.includes('your_actual')) {
      console.log('✓ DB_PASSWORD is set');
    } else {
      passwordIsPlaceholder = true;
      console.log('⚠ DB_PASSWORD is still a placeholder!');
      console.log('   Current value:', password || '(empty)');
      console.log('   → Edit server/.env and set your real MySQL password');
    }
  }
});

if (!hasPassword) {
  console.log('⚠ DB_PASSWORD not found in .env file');
}

console.log('\n=== Configuration Summary ===');
lines.forEach(line => {
  if (line.trim() && !line.trim().startsWith('#')) {
    const [key, value] = line.split('=');
    if (key && value) {
      if (key.trim() === 'DB_PASSWORD') {
        console.log(`  ${key.trim()}: ${value ? '***' : '(empty)'}`);
      } else {
        console.log(`  ${key.trim()}: ${value.trim()}`);
      }
    }
  }
});

if (passwordIsPlaceholder || !hasPassword) {
  console.log('\n✗ Please fix the DB_PASSWORD in server/.env before starting the server');
  process.exit(1);
} else {
  console.log('\n✓ .env file looks good!');
  console.log('\nNext step: Start the server with:');
  console.log('  node server/index.js');
  console.log('  or');
  console.log('  npm run dev:server');
}

