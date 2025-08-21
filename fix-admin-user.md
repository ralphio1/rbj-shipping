# Fix Admin User Creation Issue

## Problem
No admin user is being created during API startup, causing all authentication to fail.

## Root Cause
Database environment variables are likely not properly set in Render, preventing the API from connecting to your Supabase database during startup.

## Solution Steps

### Step 1: Verify Database Environment Variables
Go to **Render Dashboard** → **karrio-api service** → **Environment tab**

**Check these variables have ACTUAL VALUES (not "sync: false"):**

```
DATABASE_HOST = your-project-ref.supabase.co
DATABASE_USERNAME = postgres
DATABASE_PASSWORD = your-actual-supabase-password
DATABASE_NAME = postgres  
DATABASE_PORT = 5432
```

**If any are missing or show "sync: false":**
1. Click "Add Environment Variable"
2. Set the key and actual value
3. Save changes
4. Redeploy service

### Step 2: Get Your Supabase Connection Details
1. Go to your **Supabase dashboard**
2. Navigate to **Settings** → **Database**
3. Copy the connection details:
   - Host: `your-project-ref.supabase.co`
   - Database name: `postgres`
   - Port: `5432`
   - User: `postgres`
   - Password: Your project password

### Step 3: Set Environment Variables in Render
For each missing variable:
1. **DATABASE_HOST**: Paste your Supabase host
2. **DATABASE_USERNAME**: `postgres`
3. **DATABASE_PASSWORD**: Paste your Supabase password  
4. **DATABASE_NAME**: `postgres`
5. **DATABASE_PORT**: `5432`

### Step 4: Redeploy and Test
1. **Redeploy** karrio-api service
2. **Check startup logs** for:
   - "Running migrations..."
   - "Creating admin user..."
   - "Admin user created successfully"
3. **Test authentication**:
   ```bash
   ./test-auth.sh admin@reboundjerseys.com "CJTRReMXKRQGfXSgo/YTgS4p8DtIj9ggZlBW1pHTmzc="
   ```

## Alternative: Manual Admin Creation via SQL

If environment variables are correct but admin creation still fails, create admin manually in Supabase:

```sql
INSERT INTO user_user (
    email, 
    password, 
    is_active, 
    is_staff, 
    is_superuser, 
    first_name,
    last_name,
    date_joined
) VALUES (
    'admin@reboundjerseys.com',
    'pbkdf2_sha256$600000$4w+wPeTOru1mmbV6oQhl/A==$WoXALvBqfRQiAzCXQutPZCRYWJGD4k+CK2/1sJC2uYE=',
    true,
    true, 
    true,
    'Admin',
    'User',
    NOW()
);
```

## Expected Results
- ✅ API startup logs show successful admin user creation
- ✅ Django admin access works: https://karrio-api.onrender.com/admin/  
- ✅ JWT authentication works for API calls
- ✅ Dashboard login works
