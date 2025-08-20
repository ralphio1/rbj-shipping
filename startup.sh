#!/bin/bash

# Karrio startup script for Render
echo "Starting Karrio startup process..."

# Run database migrations
echo "Running database migrations..."
karrio migrate

# Collect static files
echo "Collecting static files..."
karrio collectstatic --noinput

# Start the main application
echo "Starting Karrio application..."
exec "$@"
