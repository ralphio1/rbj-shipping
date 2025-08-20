# 🚀 Karrio Deployment Guide for Render

This guide provides step-by-step instructions for deploying your custom Karrio setup on Render.

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ [Render Account](https://render.com) (free tier available)
- ✅ [Supabase Account](https://supabase.com) (free tier available)
- ✅ [Git Repository](https://github.com) with your code
- ✅ [Docker](https://docker.com) installed locally (for testing)

## 🏗️ Step 1: Supabase Database Setup

### 1.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **"New Project"**
3. Choose your organization
4. Enter project details:
   - **Name**: `karrio-shipping` (or your preferred name)
   - **Database Password**: Generate a strong password
   - **Region**: Choose closest to your users
5. Click **"Create new project"**

### 1.2 Get Database Connection Details

1. In your Supabase project dashboard, go to **Settings** → **Database**
2. Note down these details:
   - **Host**: `your-project.supabase.co`
   - **Database name**: `postgres`
   - **Port**: `5432`
   - **User**: `postgres`
   - **Password**: (the one you created)

### 1.3 Enable Row Level Security (Optional but Recommended)

1. Go to **Authentication** → **Policies**
2. Enable RLS for production tables if needed

## 🔑 Step 2: Render Key Value Setup

### 2.1 Create Key Value Service

1. In your Render dashboard, click **"New +"**
2. Select **"Key Value"**
3. Configure the service:
   - **Name**: `karrio-redis` (or your preferred name)
   - **Plan**: `Starter` (free tier)
   - **Region**: Choose closest to your services
4. Click **"Create Key Value"**

### 2.2 Note Connection Details

1. After creation, note the **Host** and **Port**
2. These will be automatically referenced in your `render.yaml`

## 🐳 Step 3: Test Local Deployment

### 3.1 Build and Test Locally

```bash
# Clone your repository
git clone <your-repo-url>
cd karrio_shipping

# Build and start local environment
make local

# Check status
make status

# View logs
make logs
```

### 3.2 Verify Services

- **API**: http://localhost:5002
- **Dashboard**: http://localhost:3000
- **Database**: localhost:5432
- **Redis**: localhost:6379

### 3.3 Stop Local Services

```bash
make stop
```

## 🚀 Step 4: Deploy to Render

### 4.1 Connect Repository

1. In Render dashboard, click **"New +"**
2. Select **"Blueprint"**
3. Connect your Git repository
4. Select the repository with your `render.yaml`

### 4.2 Configure Environment Variables

Before deploying, set these environment variables in Render:

#### Required Variables

```bash
# Supabase Database
SUPABASE_HOST=your-project.supabase.co
SUPABASE_USER=postgres
SUPABASE_PASSWORD=your-supabase-password
SUPABASE_DB=postgres

# Karrio Configuration
ADMIN_EMAIL=admin@yourdomain.com
ADMIN_PASSWORD=your-admin-password

# URLs (update with your actual Render URLs)
KARRIO_PUBLIC_URL=https://your-api.onrender.com
CORS_ALLOWED_ORIGINS=https://your-dashboard.onrender.com
```

#### Optional Variables

```bash
# Worker Configuration
KARRIO_WORKERS=2
BACKGROUND_WORKERS=2

# Debug Mode
DEBUG_MODE=False
```

### 4.3 Deploy Blueprint

1. Click **"Apply"** to deploy your blueprint
2. Render will create:
   - **karrio-api**: Main API service
   - **karrio-worker**: Background job processor
   - **karrio-dashboard**: Frontend dashboard
   - **karrio-redis**: Redis-compatible storage

### 4.4 Monitor Deployment

1. Watch the deployment logs for each service
2. Check for any errors or warnings
3. Wait for all services to show "Live" status

## 🔍 Step 5: Verify Deployment

### 5.1 Check Service Status

1. In Render dashboard, verify all services are running
2. Check health check endpoints:
   - **API**: `https://your-api.onrender.com/`
   - **Dashboard**: `https://your-dashboard.onrender.com/`

### 5.2 Test API Endpoints

```bash
# Test API health
curl https://your-api.onrender.com/

# Test dashboard
curl https://your-dashboard.onrender.com/
```

### 5.3 Check Logs

1. In Render dashboard, go to each service
2. Check the **Logs** tab for any errors
3. Monitor for successful startup messages

## 🔧 Step 6: Post-Deployment Configuration

### 6.1 Database Migrations

The API service should automatically run migrations on startup. Check logs to confirm:

```bash
# Look for these messages in API logs:
# "Running migrations..."
# "Migrations completed successfully"
```

### 6.2 Admin User Creation

Check logs for admin user creation:

```bash
# Look for these messages in API logs:
# "Creating admin user..."
# "Admin user created successfully"
```

### 6.3 Static Files

Check logs for static file collection:

```bash
# Look for these messages in API logs:
# "Collecting static files..."
# "Static files collected successfully"
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Database Connection Failed

**Symptoms**: API service fails to start, database connection errors

**Solutions**:
- Verify Supabase credentials in environment variables
- Check if Supabase project is active
- Ensure database password is correct
- Check network connectivity

#### 2. Redis Connection Failed

**Symptoms**: Worker service fails to start, Redis connection errors

**Solutions**:
- Verify Key Value service is running
- Check environment variable references
- Ensure service names match in `render.yaml`

#### 3. Build Failures

**Symptoms**: Docker build fails during deployment

**Solutions**:
- Check Dockerfile syntax
- Verify all required files are present
- Check `.dockerignore` configuration
- Test builds locally first

#### 4. Service Health Check Failures

**Symptoms**: Services show as unhealthy

**Solutions**:
- Check service logs for errors
- Verify health check endpoints
- Check environment variable configuration
- Ensure all dependencies are available

### Debug Commands

```bash
# Check service status
make status

# View specific service logs
make logs-api
make logs-dash

# Check Docker images
docker images | grep karrio

# Test local environment
make test
```

## 📊 Monitoring & Maintenance

### 1. Regular Health Checks

- Monitor service status in Render dashboard
- Check health check endpoints regularly
- Review logs for errors or warnings

### 2. Performance Monitoring

- Monitor resource usage in Render dashboard
- Check database performance in Supabase
- Monitor Redis usage and performance

### 3. Updates & Maintenance

- Keep Karrio base images updated
- Monitor for security updates
- Test updates in staging environment first

## 🔄 Updating Your Deployment

### 1. Code Updates

```bash
# Make your changes
git add .
git commit -m "Update description"
git push origin main

# Render will automatically redeploy
```

### 2. Environment Variable Changes

1. Update variables in Render dashboard
2. Redeploy affected services
3. Monitor logs for any issues

### 3. Major Updates

1. Test changes locally first
2. Update base images if needed
3. Deploy to staging environment
4. Deploy to production after testing

## 📞 Support

### Getting Help

- **Render Support**: [render.com/docs/help](https://render.com/docs/help)
- **Supabase Support**: [supabase.com/support](https://supabase.com/support)
- **Karrio Issues**: [github.com/karrioapi/karrio/issues](https://github.com/karrioapi/karrio/issues)

### Useful Resources

- [Karrio Documentation](https://www.karrio.io/docs)
- [Render Documentation](https://render.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Docker Documentation](https://docs.docker.com)

---

## 🎉 Congratulations!

You've successfully deployed Karrio on Render with:

- ✅ Custom Docker images
- ✅ Supabase PostgreSQL database
- ✅ Render Key Value (Redis)
- ✅ Background worker processing
- ✅ Production-ready configuration

Your shipping platform is now live and ready to handle shipments! 🚚📦
