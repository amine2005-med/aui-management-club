# AUI Clubs Management System

A React and TypeScript frontend, Express API, and MySQL database for managing students, clubs, memberships, events, attendance, sponsors, budgets, and room reservations.

## Requirements

- Node.js 18 or newer and npm
- MySQL 8 or newer

## Setup

1. Install JavaScript dependencies with `npm install`.
2. Create the database and sample data by running `mohamed_amine_aouragh_final_implimentation_init.sql` in MySQL. The script creates the database if it does not exist and does not drop existing data.
3. Copy `server/env.example` to `server/.env` and set your MySQL credentials.
4. Start the API with `npm run dev:server` (or `npm run server`). It listens on port 5001 by default.
5. In another terminal, run `npm run dev`. Open `http://localhost:3000`.

To use a remote API, set `VITE_API_URL` to its origin, such as `https://api.example.com`; the frontend appends `/api`.

## Commands

- `npm run dev` — start the Vite development server
- `npm run dev:server` — start the API with automatic restarts
- `npm run server` — start the API
- `npm run build` — create the production frontend in `build/`

## API

Each resource supports `GET`, `POST`, `PUT /:id`, and `DELETE /:id` under `/api`: `students`, `clubs`, `memberships`, `events`, `participations`, `sponsors`, `budgets`, and `room-reservations`. `GET /api/health` checks both the API and its MySQL connection.

## Repository hygiene

Keep credentials in the ignored `server/.env` file. Never commit `.env` files, `node_modules`, or generated build output. `server/env.example` contains placeholders only.
