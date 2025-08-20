# Karrio Makefile
# Provides convenient shortcuts for common operations

.PHONY: help build test stop status logs clean deploy local

# Default target
help:
	@echo "🚀 Karrio Development Commands"
	@echo "================================"
	@echo ""
	@echo "Development:"
	@echo "  make build     - Build Docker images"
	@echo "  make test      - Start local development environment"
	@echo "  make stop      - Stop local services"
	@echo "  make status    - Show service status"
	@echo "  make logs      - Show all service logs"
	@echo "  make logs-api  - Show API service logs"
	@echo "  make logs-dash - Show Dashboard service logs"
	@echo "  make clean     - Clean up Docker resources"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy    - Full deployment process"
	@echo "  make local     - Local development setup"
	@echo ""

# Build Docker images
build:
	@echo "🔨 Building Docker images..."
	docker build -f Dockerfile.api -t karrio-api:latest .
	docker build -f Dockerfile.dashboard -t karrio-dashboard:latest .
	@echo "✅ Images built successfully!"

# Start local development environment
test:
	@echo "🚀 Starting local development environment..."
	docker-compose up -d
	@echo "⏳ Waiting for services to be ready..."
	@sleep 30
	@echo "✅ Services are running!"
	@echo "📱 API: http://localhost:5002"
	@echo "🖥️  Dashboard: http://localhost:3000"
	@echo "🗄️  Database: localhost:5432"
	@echo "🔴 Redis: localhost:6379"

# Stop local services
stop:
	@echo "🛑 Stopping local services..."
	docker-compose down
	@echo "✅ Services stopped!"

# Show service status
status:
	@echo "📊 Service Status:"
	docker-compose ps

# Show all service logs
logs:
	@echo "📝 Showing all service logs..."
	docker-compose logs -f

# Show API service logs
logs-api:
	@echo "📝 Showing API service logs..."
	docker-compose logs -f api

# Show Dashboard service logs
logs-dash:
	@echo "📝 Showing Dashboard service logs..."
	docker-compose logs -f dashboard

# Clean up Docker resources
clean:
	@echo "🧹 Cleaning up Docker resources..."
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "✅ Cleanup completed!"

# Full deployment process
deploy:
	@echo "🚀 Starting full deployment process..."
	./deploy.sh deploy

# Local development setup
local: build test
	@echo "🎉 Local development environment is ready!"
	@echo "Use 'make logs' to view logs or 'make stop' to stop services"
