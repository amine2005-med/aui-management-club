# Quick Start Guide - What to Do Now

## Step 1: Fix the MySQL Password (REQUIRED)

1. **Open the file:** `server/.env` in a text editor (Notepad, VS Code, etc.)

2. **Find this line:**
   ```
   DB_PASSWORD=your_mysql_password
   ```

3. **Replace it with your actual MySQL root password:**
   ```
   DB_PASSWORD=your_actual_password_here
   ```
   (Replace `your_actual_password_here` with your real MySQL password)

4. **Save the file**

## Step 2: Reinstall Dependencies (Fix pnpm issue)

Open PowerShell/Command Prompt and run:

```powershell
cd path\to\project

# Remove old node_modules
rmdir /s /q node_modules

# Reinstall (try these in order until one works)
npm install
# OR if npm doesn't work:
"C:\Program Files\nodejs\npm.cmd" install
# OR if node is in a different location, find it first:
where node
# Then use that path with \npm.cmd
```

## Step 3: Make Sure Database Exists

If you haven't created the database yet:

```powershell
mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql
```

Enter your MySQL password when prompted.

## Step 4: Start the Backend Server

Open a **NEW terminal window** and run:

```powershell
cd path\to\project

# Try these in order:
node server/index.js
# OR
npm run dev:server
```

**You should see:**
```
Database connection pool created
Connected to database: aui_clubs
Server is running on http://localhost:5001
```

**If you see errors**, they will tell you exactly what's wrong (usually the password).

## Step 5: Test the Backend

Open your browser and go to:
```
http://localhost:5001/api/health
```

You should see: `{"status":"ok","message":"Server is running"}`

## Step 6: Refresh Your Frontend

Once the backend is running, go back to:
```
http://localhost:3000
```

Refresh the page - the error should be gone!

---

## Quick Checklist

- [ ] Edited `server/.env` and set real MySQL password
- [ ] Reinstalled dependencies with `npm install`
- [ ] Created database (if needed)
- [ ] Started backend server (`node server/index.js`)
- [ ] Tested backend at `http://localhost:5001/api/health`
- [ ] Refreshed frontend at `http://localhost:3000`

## Still Having Issues?

**If you see "Access denied" error:**
→ Your MySQL password in `.env` is wrong

**If you see "Unknown database":**
→ Run the SQL script to create the database

**If you see "ECONNREFUSED":**
→ MySQL service is not running (start it in Windows Services)

**If npm/node commands don't work:**
→ Restart your terminal after installing Node.js

