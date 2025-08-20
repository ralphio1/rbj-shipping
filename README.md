# Karrio Shipping Platform on Render

This repository contains a custom Karrio deployment setup for Render, featuring custom Docker images, Supabase Postgres integration, and Render Key Value (Redis-compatible) for background jobs and caching.

## 🚀 Features

- **Custom Docker Images**: Extended official Karrio images with custom configurations
- **Supabase Integration**: PostgreSQL database hosted on Supabase
- **Render Key Value**: Redis-compatible service for job queues and caching
- **Plugin System**: Extensible architecture for custom integrations
- **Production Ready**: Optimized for Render deployment with proper health checks

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Karrio API    │    │  Karrio Worker  │    │ Karrio Dashboard│
│   (Web Service) │    │   (Worker)      │    │  (Web Service)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Render Key Value│
                    │   (Redis)       │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Supabase       │
                    │  PostgreSQL     │
                    └─────────────────┘
```

## 📋 Prerequisites

- [Render Account](https://render.com)
- [Supabase Account](https://supabase.com)
- [Docker](https://docker.com) (for local development)
- [Git](https://git-scm.com)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd karrio_shipping
```

### 2. Local Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 3. Render Deployment

1. **Connect your repository to Render**
2. **Set environment variables** (see Environment Variables section)
3. **Deploy using the Blueprint**

## 🔧 Configuration

### Environment Variables

#### Required for Production

```bash
# Supabase Database
SUPABASE_HOST=your-project.supabase.co
SUPABASE_USER=postgres
SUPABASE_PASSWORD=your-password
SUPABASE_DB=postgres

# Karrio Configuration
SECRET_KEY=your-secret-key
ADMIN_EMAIL=admin@yourdomain.com
ADMIN_PASSWORD=your-admin-password

# URLs
KARRIO_PUBLIC_URL=https://your-api.onrender.com
CORS_ALLOWED_ORIGINS=https://your-dashboard.onrender.com
```

#### Optional

```bash
# Worker Configuration
KARRIO_WORKERS=2
BACKGROUND_WORKERS=2

# Debug Mode
DEBUG_MODE=False
```

### Supabase Setup

1. **Create a new Supabase project**
2. **Get connection details**:
   - Host: `your-project.supabase.co`
   - Database: `postgres`
   - Port: `5432`
   - Username: `postgres`
   - Password: (from your project settings)

3. **Enable Row Level Security (RLS)** for production use

### Render Key Value Setup

1. **Create a new Key Value service** in Render
2. **Note the host and port** for environment variables
3. **Use the service name** in your `render.yaml`

## 🐳 Custom Docker Images

### API Image (`Dockerfile.api`)

- Extends `karrio/server:latest`
- Includes custom configuration files
- Supports plugin system
- Production-optimized settings

### Dashboard Image (`Dockerfile.dashboard`)

- Extends `karrio/dashboard:latest`
- Custom dashboard components support
- Production-ready configuration

## 🔌 Plugin System

### Plugin Structure

```
plugins/
├── __init__.py
└── custom_integration/
    ├── __init__.py
    ├── hooks.py
    └── services.py
```

### Creating Custom Plugins

1. **Create plugin directory** in `plugins/`
2. **Implement Plugin class** with `initialize()` method
3. **Add event hooks** using `@on_event` decorator
4. **Create custom services** for business logic

### Example Plugin

```python
from karrio.core.plugins import Plugin
from karrio.core.events import on_event

class MyPlugin(Plugin):
    id = 'my_plugin'
    name = 'My Custom Plugin'
    
    def initialize(self):
        # Plugin initialization logic
        pass

@on_event('shipment.created')
def handle_shipment_created(shipment):
    # Custom logic here
    pass
```

## 🚀 Deployment

### Render Blueprint

The `render.yaml` file defines:

- **karrio-api**: Main API service (Web Service)
- **karrio-worker**: Background job processor (Worker)
- **karrio-dashboard**: Frontend dashboard (Web Service)
- **rebound-karrio-redis**: Redis-compatible storage (Key Value)

### Deployment Steps

1. **Push to Git repository**
2. **Connect repository to Render**
3. **Deploy using Blueprint**
4. **Set environment variables**
5. **Monitor deployment logs**

## 🔍 Monitoring & Health Checks

### Health Check Endpoints

- **API**: `https://your-api.onrender.com/`
- **Dashboard**: `https://your-dashboard.onrender.com/`

### Logs

- **API Logs**: Available in Render dashboard
- **Worker Logs**: Available in Render dashboard
- **Database Logs**: Available in Supabase dashboard

## 🛠️ Development

### Local Development

```bash
# Start development environment
docker-compose up -d

# View specific service logs
docker-compose logs api
docker-compose logs worker
docker-compose logs dashboard

# Access services
# API: http://localhost:5002
# Dashboard: http://localhost:3000
# Database: localhost:5432
# Redis: localhost:6379
```

### Testing

```bash
# Run tests (if available)
docker-compose exec api karrio test

# Check database migrations
docker-compose exec api karrio migrate --check
```

## 🔒 Security

### Production Security

- **HTTPS**: Enabled by default on Render
- **CORS**: Configured for specific origins
- **Database**: SSL connections to Supabase
- **Secrets**: Generated automatically by Render

### Environment Variables

- Never commit sensitive data to Git
- Use Render's environment variable system
- Generate secrets using Render's built-in generators

## 📚 Documentation

- [Karrio Documentation](https://www.karrio.io/docs)
- [Render Documentation](https://render.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Docker Documentation](https://docs.docker.com)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker Compose
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- **Karrio Issues**: [GitHub Issues](https://github.com/karrioapi/karrio/issues)
- **Render Support**: [Render Support](https://render.com/docs/help)
- **Supabase Support**: [Supabase Support](https://supabase.com/support)

## 🔄 Updates

### Updating Karrio

1. **Update base images** in Dockerfiles
2. **Test locally** with Docker Compose
3. **Deploy to staging** environment
4. **Deploy to production** after testing

### Updating Dependencies

1. **Update requirements** files
2. **Rebuild Docker images**
3. **Test functionality**
4. **Deploy updates**

---

**Note**: This setup is optimized for Render deployment. For other platforms, you may need to adjust the configuration files and deployment scripts.
