-- Runs automatically on first container start (docker-entrypoint-initdb.d).
-- Keep this minimal: create roles/extensions only. Schema belongs in livestock-db.
-- The default database and user are already created from env vars.
SELECT 'livestock db initialised' AS status;
