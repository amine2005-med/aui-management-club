# How to Start the Backend Server

## Quick Start

1. **Open a NEW terminal/PowerShell window**

2. **Navigate to the project:**
   ```powershell
   cd path\to\project
   ```

3. **Start the server:**
   ```powershell
   npm run dev:server
   ```

## What You Should See

If everything is working, you'll see:
```
Database connection pool created
Connected to database: aui_clubs
Server is running on http://localhost:5001
Database: aui_clubs on localhost
```

## Common Errors and Fixes

### Error: "Access denied for user 'root'@'localhost'"

**Fix:** Your MySQL password is wrong in `server/.env`

1. Open `server/.env` file
2. Change this line:
   ```
   DB_PASSWORD=your_actual_mysql_password
   ```
3. Replace with your real MySQL root password
4. Save the file
5. Restart the server

### Error: "Unknown database 'aui_clubs'"

**Fix:** The database doesn't exist. Create it:

```powershell
mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql
```

Or manually:
1. Open MySQL: `mysql -u root -p`
2. Run: `source mohamed_amine_aouragh_final_implimentation_init.sql`

### Error: "ECONNREFUSED" or "Cannot connect to MySQL server"

**Fix:** MySQL service is not running

1. Open Windows Services (services.msc)
2. Find "MySQL" service
3. Right-click → Start
4. Restart the backend server

### Error: "Port 5001 is already in use"

**Fix:** Another process is using port 5001

1. Find what's using the port:
   ```powershell
   netstat -ano | findstr :5001
   ```
2. Kill the process or change PORT in `server/.env`

## Verify Server is Running

Open your browser and go to:
```
http://localhost:5001/api/health
```

You should see:
```json
{"status":"ok","message":"Server is running"}
```

If you see this, the backend is working! ✅

## Still Having Issues?

1. **Check the terminal output** - it will show specific error messages
2. **Verify MySQL is running:**
   ```powershell
   mysql -u root -p
   ```
3. **Check your .env file** is in `server/.env` (not in root directory)
4. **Make sure you're in the correct directory** when running commands

