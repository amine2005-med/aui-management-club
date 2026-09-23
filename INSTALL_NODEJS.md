# Installing Node.js and Running the Project

## Issue
You're getting errors because `pnpm` and `npm` are not recognized. This means Node.js is either not installed or not in your system PATH.

## Solution: Install Node.js

### Option 1: Install Node.js (Recommended)

1. **Download Node.js:**
   - Go to: https://nodejs.org/
   - Download the LTS (Long Term Support) version for Windows
   - This will install both Node.js and npm

2. **Install Node.js:**
   - Run the installer
   - Make sure to check "Add to PATH" during installation
   - Complete the installation

3. **Verify Installation:**
   - Close and reopen your PowerShell/terminal
   - Run these commands to verify:
     ```powershell
     node --version
     npm --version
     ```

4. **Install Project Dependencies:**
   ```powershell
   cd path\to\project
   npm install
   ```

### Option 2: Install pnpm (if you prefer pnpm)

After installing Node.js, you can install pnpm globally:
```powershell
npm install -g pnpm
```

Then use:
```powershell
pnpm install
```

## After Installing Node.js

Once Node.js is installed, follow these steps:

1. **Navigate to project directory:**
   ```powershell
   cd path\to\project
   ```

2. **Install dependencies:**
   ```powershell
   npm install
   ```

3. **Set up database** (see SETUP_INSTRUCTIONS.md)

4. **Configure .env file** (see SETUP_INSTRUCTIONS.md)

5. **Run the project:**
   - Terminal 1: `npm run dev:server`
   - Terminal 2: `npm run dev`

## Quick Check

If Node.js is installed but not in PATH, you might need to:
- Restart your terminal/PowerShell
- Or manually add Node.js to your system PATH:
  - Usually installed at: `C:\Program Files\nodejs\`
  - Add this to your system PATH environment variable

