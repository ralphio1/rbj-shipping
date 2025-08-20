"""
Custom Karrio settings for Render deployment
This file extends the default Karrio configuration
"""

import os
from karrio.server.settings import *

# Production settings
DEBUG = os.getenv('DEBUG_MODE', 'False').lower() == 'true'
SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key-here')

# Database configuration
DATABASES = {
    'default': {
        'ENGINE': f"django.db.backends.{os.getenv('DATABASE_ENGINE', 'postgresql_psycopg2')}",
        'NAME': os.getenv('DATABASE_NAME', 'karrio'),
        'USER': os.getenv('DATABASE_USERNAME', 'postgres'),
        'PASSWORD': os.getenv('DATABASE_PASSWORD', ''),
        'HOST': os.getenv('DATABASE_HOST', 'localhost'),
        'PORT': os.getenv('DATABASE_PORT', '5432'),
        'OPTIONS': {
            'sslmode': 'require' if os.getenv('USE_HTTPS', 'False').lower() == 'true' else 'disable',
        },
    }
}

# Redis configuration
REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
REDIS_PORT = int(os.getenv('REDIS_PORT', 6379))
REDIS_DB = int(os.getenv('REDIS_DB', 0))

# Cache configuration
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}',
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}

# Celery configuration
CELERY_BROKER_URL = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}'
CELERY_RESULT_BACKEND = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}'

# Security settings
USE_HTTPS = os.getenv('USE_HTTPS', 'False').lower() == 'true'
ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', '*').split(',')
CORS_ALLOWED_ORIGINS = os.getenv('CORS_ALLOWED_ORIGINS', '').split(',')

if USE_HTTPS:
    SECURE_SSL_REDIRECT = True
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True

# Static files
STATIC_ROOT = os.getenv('STATIC_ROOT_DIR', '/karrio/static')
STATIC_URL = '/static/'

# Media files
MEDIA_ROOT = os.getenv('MEDIA_ROOT_DIR', '/karrio/media')
MEDIA_URL = '/media/'

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': os.path.join(os.getenv('LOG_DIR', '/karrio/log'), 'karrio.log'),
            'formatter': 'verbose',
        },
    },
    'root': {
        'handlers': ['console', 'file'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
            'propagate': False,
        },
        'karrio': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}

# Worker configuration
KARRIO_WORKERS = int(os.getenv('KARRIO_WORKERS', 2))
BACKGROUND_WORKERS = int(os.getenv('BACKGROUND_WORKERS', 2))
DETACHED_WORKER = os.getenv('DETACHED_WORKER', 'False').lower() == 'true'

# Plugin configuration
PLUGINS_DIR = os.getenv('PLUGINS_DIR', '/karrio/plugins')

# Add plugins to INSTALLED_APPS if they exist
if os.path.exists(PLUGINS_DIR):
    for plugin_dir in os.listdir(PLUGINS_DIR):
        plugin_path = os.path.join(PLUGINS_DIR, plugin_dir)
        if os.path.isdir(plugin_path) and os.path.exists(os.path.join(plugin_path, '__init__.py')):
            INSTALLED_APPS += (f'plugins.{plugin_dir}',)

# Custom middleware for production
if not DEBUG:
    MIDDLEWARE = [
        'django.middleware.security.SecurityMiddleware',
    ] + MIDDLEWARE + [
        'django.middleware.security.SecurityMiddleware',
    ]
