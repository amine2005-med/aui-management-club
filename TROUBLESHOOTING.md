# Troubleshooting: Backend Server Not Running

## Current Issue
You're seeing "Failed to fetch" which means the frontend can't connect to the backend on port 5001.

## Quick Fixes

### 1. Check if Backend Server is Running

Open a **NEW terminal window** and run:
```powershell
cd path\to\project
npm run dev:server
```

You should see:
```
Server is running on http://localhost:5001
Database connection pool created
```

If you see errors, check the following:

### 2. Check MySQL Configuration

Edit `server/.env` and make sure it has your correct MySQL password:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_actual_mysql_password_here
DB_NAME=aui_clubs
PORT=5001
```

**Important:** Replace `your_actual_mysql_password_here` with your real MySQL root password.

### 3. Make Sure MySQL is Running

- Check if MySQL service is running in Windows Services
- Or try connecting to MySQL:
  ```powershell
  mysql -u root -p
  ```

### 4. Make Sure Database Exists

The database `aui_clubs` must exist. If not, run:
```powershell
mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql
```

### 5. Common Error Messages

**"Access denied for user 'root'@'localhost'"**
- Your MySQL password in `.env` is incorrect
- Update `DB_PASSWORD` in `server/.env`

**"Unknown database 'aui_clubs'"**
- Database doesn't exist
- Run the SQL initialization script

**"ECONNREFUSED" or "Cannot connect to MySQL server"**
- MySQL service is not running
- Start MySQL service

**"Port 5001 is already in use"**
- Another process is using port 5001
- Either stop that process or change PORT in `.env`

## Step-by-Step: Start Backend Server

1. **Open a new terminal/PowerShell window**

2. **Navigate to project:**
   ```powershell
   cd path\to\project
   ```

3. **Start the backend:**
   ```powershell
   npm run dev:server
   ```

4. **You should see:**
   ```
   Database connection pool created
   Server is running on http://localhost:5001
   ```

5. **Keep this terminal open** - the backend must stay running

6. **In your browser**, refresh the page at `http://localhost:3000`

## Verify Backend is Working

Open a browser and go to:
```
http://localhost:5001/api/health
```

You should see:
```json
{"status":"ok","message":"Server is running"}
```

If this works, the backend is running correctly!

