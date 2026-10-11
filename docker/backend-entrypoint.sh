#!/bin/bash
# docker/backend-entrypoint.sh
# Runs Alembic migrations then starts the Uvicorn server.
set -e

echo "⏳ Waiting for PostgreSQL to be ready..."
until python -c "
import psycopg2, os
psycopg2.connect(os.environ['DATABASE_URL'].replace('postgresql+psycopg2://', 'postgresql://'))
" 2>/dev/null; do
  echo "  PostgreSQL not ready yet — retrying in 2s..."
  sleep 2
done

echo "✅ PostgreSQL is ready."

echo "🔄 Running Alembic migrations..."
alembic upgrade head

echo "🌱 Seeding demo data (idempotent)..."
python data_analysis/scripts/seed_backend.py || echo "⚠️  Seed skipped (already seeded or error)."

echo "🚀 Starting SensAI API on port 8000..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
