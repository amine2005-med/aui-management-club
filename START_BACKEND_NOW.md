# START THE BACKEND SERVER NOW

## The Problem
Your frontend is running but the backend server is NOT running on port 5001.

## Solution: Start the Backend Server

### Option 1: Using Command Line (Recommended)

1. **Open a NEW PowerShell or Command Prompt window**
   (Keep your frontend terminal open - you need BOTH running)

2. **Navigate to the project:**
   ```powershell
   cd path\to\project
   ```

3. **Start the backend:**
   ```powershell
   node server/index.js
   ```

### Option 2: Using the Batch File

Double-click `start-backend.bat` in the project folder.

---

## What You Should See

### ✅ SUCCESS:
```
Database connection pool created
Connected to database: aui_clubs
Server is running on http://localhost:5001
Database: aui_clubs on localhost
```

### ❌ COMMON ERRORS:

**Error: "Access denied for user 'root'@'localhost'"**
- **Fix:** Your MySQL password is wrong
- Edit `server/.env` file
- Change `DB_PASSWORD=your_mysql_password` to your real password
- Save and restart the server

**Error: "Unknown database 'aui_clubs'"**
- **Fix:** Database doesn't exist
- Run: `mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql`

**Error: "ECONNREFUSED" or "Cannot connect to MySQL server"**
- **Fix:** MySQL service is not running
- Start MySQL service in Windows Services

---

## After Backend Starts Successfully

1. **Test it:** Open browser to `http://localhost:5001/api/health`
   - Should see: `{"status":"ok","message":"Server is running"}`

2. **Refresh frontend:** Go to `http://localhost:3000` and refresh
   - The error should be gone!

---

## Quick Checklist

- [ ] Opened a NEW terminal window
- [ ] Navigated to project directory
- [ ] Ran `node server/index.js`
- [ ] Saw "Server is running on http://localhost:5001"
- [ ] Tested `http://localhost:5001/api/health` in browser
- [ ] Refreshed frontend at `http://localhost:3000`

---

## IMPORTANT: You Need TWO Terminals Running

- **Terminal 1:** Frontend (`npm run dev` or `pnpm run dev`) - Already running ✅
- **Terminal 2:** Backend (`node server/index.js`) - **YOU NEED TO START THIS NOW** ⚠️

**Keep BOTH terminals open!** The backend must stay running.

