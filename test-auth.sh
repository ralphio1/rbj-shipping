#!/bin/bash

# Quick auth tester for Karrio API
# Usage: ./test-auth.sh email password

EMAIL="${1:-contact@reboundjerseys.com}"
PASSWORD="${2:-ReboundJerseys2025}"

echo "🧪 Testing Karrio Authentication"
echo "================================="
echo "Email: $EMAIL"
echo "Password: $PASSWORD"
echo ""

echo "📡 Making request to API..."
response=$(curl -s -w "%{http_code}" -X POST https://karrio-api.onrender.com/api/token \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" \
    -o /tmp/karrio_auth_response.json)

echo "HTTP Status: $response"
echo ""

if [ "$response" = "200" ]; then
    echo "✅ SUCCESS! Authentication successful"
    echo "Response:"
    cat /tmp/karrio_auth_response.json | jq . 2>/dev/null || cat /tmp/karrio_auth_response.json
elif [ "$response" = "401" ]; then
    echo "❌ FAILED! Authentication failed (401)"
    echo "Error details:"
    cat /tmp/karrio_auth_response.json | jq . 2>/dev/null || cat /tmp/karrio_auth_response.json
else
    echo "⚠️  Unexpected response code: $response"
    echo "Response:"
    cat /tmp/karrio_auth_response.json
fi

echo ""
echo "💡 Tips:"
echo "  - Check user exists in Supabase database"
echo "  - Verify is_active = true"  
echo "  - Confirm password is properly hashed"
echo "  - Try with admin@reboundjerseys.com and generated password"

# Cleanup
rm -f /tmp/karrio_auth_response.json
