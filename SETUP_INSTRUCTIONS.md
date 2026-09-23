# Setup Instructions

## Prerequisites
- Node.js (v18 or higher) - Make sure npm is in your PATH
- MySQL Server (v8.0 or higher) - Make sure MySQL is running

## Step 1: Install Dependencies

Open a terminal in the project directory and run:
```bash
npm install
# or if you have pnpm:
pnpm install
```

## Step 2: Set Up Database

1. Make sure MySQL server is running
2. Create the database by running:
```bash
mysql -u root -p < mohamed_amine_aouragh_final_implimentation_init.sql
```

Or manually:
- Open MySQL command line: `mysql -u root -p`
- Run: `source mohamed_amine_aouragh_final_implimentation_init.sql`

This creates the `aui_clubs` database with all tables and sample data.

## Step 3: Configure Environment Variables

1. Navigate to the `server` directory
2. Copy `env.example` to `.env`:
```bash
cd server
copy env.example .env
```

3. Edit `server/.env` with your MySQL credentials:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password_here
DB_NAME=aui_clubs
PORT=5001
```

## Step 4: Run the Application

You need to run TWO servers simultaneously:

### Terminal 1 - Backend Server:
```bash
npm run server
# or for auto-reload during development:
npm run dev:server
```

The backend will start on `http://localhost:5001`

### Terminal 2 - Frontend Development Server:
```bash
npm run dev
# or if using pnpm:
pnpm run dev
```

The frontend will start on `http://localhost:3000`

## Step 5: Access the Application

Open your browser and navigate to:
```
http://localhost:3000
```

## Troubleshooting

- If you get "Cannot find module" errors, make sure you ran `npm install`
- If the backend can't connect to MySQL, check your `.env` file credentials
- If the frontend can't connect to the backend, make sure the backend is running on port 5001
- Make sure MySQL server is running before starting the backend

