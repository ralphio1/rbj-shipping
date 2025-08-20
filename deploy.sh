#!/bin/bash

# Karrio Deployment Script for Render
# This script helps automate the deployment process

set -e

echo "🚀 Karrio Deployment Script for Render"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# Build Docker images locally
build_images() {
    print_status "Building Docker images..."
    
    # Build API image
    print_status "Building Karrio API image..."
    docker build -f Dockerfile.api -t karrio-api:latest .
    
    # Build Dashboard image
    print_status "Building Karrio Dashboard image..."
    docker build -f Dockerfile.dashboard -t karrio-dashboard:latest .
    
    print_success "Docker images built successfully!"
}

# Test local deployment
test_local() {
    print_status "Testing local deployment..."
    
    # Start services
    docker-compose up -d
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 30
    
    # Check if services are running
    if docker-compose ps | grep -q "Up"; then
        print_success "Local deployment is running successfully!"
        print_status "Services available at:"
        print_status "  - API: http://localhost:5002"
        print_status "  - Dashboard: http://localhost:3000"
        print_status "  - Database: localhost:5432"
        print_status "  - Redis: localhost:6379"
    else
        print_error "Local deployment failed. Check logs with: docker-compose logs"
        exit 1
    fi
}

# Stop local services
stop_local() {
    print_status "Stopping local services..."
    docker-compose down
    print_success "Local services stopped!"
}

# Show deployment status
show_status() {
    print_status "Current deployment status:"
    docker-compose ps
}

# Show logs
show_logs() {
    local service=${1:-"all"}
    
    if [ "$service" = "all" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs -f
    else
        print_status "Showing logs for $service service..."
        docker-compose logs -f "$service"
    fi
}

# Help function
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build Docker images"
    echo "  test        Test local deployment"
    echo "  stop        Stop local services"
    echo "  status      Show deployment status"
    echo "  logs [SERVICE] Show logs (default: all services)"
    echo "  deploy      Full deployment process"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build                    # Build images only"
    echo "  $0 test                     # Test local deployment"
    echo "  $0 logs api                 # Show API logs"
    echo "  $0 deploy                   # Full deployment process"
}

# Main deployment function
deploy() {
    print_status "Starting full deployment process..."
    
    check_prerequisites
    build_images
    test_local
    
    print_success "Deployment completed successfully!"
    print_status ""
    print_status "Next steps:"
    print_status "1. Push your code to Git repository"
    print_status "2. Connect repository to Render"
    print_status "3. Set environment variables in Render"
    print_status "4. Deploy using the Blueprint (render.yaml)"
    print_status ""
    print_status "For local development:"
    print_status "  - View logs: $0 logs"
    print_status "  - Stop services: $0 stop"
    print_status "  - Check status: $0 status"
}

# Main script logic
case "${1:-help}" in
    "build")
        check_prerequisites
        build_images
        ;;
    "test")
        test_local
        ;;
    "stop")
        stop_local
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs "$2"
        ;;
    "deploy")
        deploy
        ;;
    "help"|*)
        show_help
        ;;
esac
