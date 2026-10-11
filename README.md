# livestock-infra

Containerised local/CI infrastructure for the Livestock Management System.
Backend and frontend repos depend on this stack but do not define it.

## Services

| Service  | Image                | Port  | Purpose                         |
|----------|----------------------|-------|---------------------------------|
| postgres | `postgres:16-alpine` | 5432  | Primary database                |
| pgbouncer| `edoburu/pgbouncer`  | 6432  | Connection pooling (app runtime)|
| adminer  | `adminer`            | 8080  | Web DB browser (dev only)       |

## Quick start

```bash
cp .env.example .env        # then edit POSTGRES_PASSWORD
make up                     # start the stack
make psql                   # open a psql shell
make logs                   # follow postgres logs
make down                   # stop (data kept)
make reset                  # stop + DELETE data (destructive)
```

## Migrations & seed

Schema lives in the sibling `livestock-db` repo; seed data in `livestock-seed`.

```bash
make migrate-up     # dbmate up
make seed           # load livestock-seed/seed/*.sql
```

Requires the [`dbmate`](https://github.com/amacneil/dbmate) binary and the repos
checked out side by side:

```
livestock/
  livestock-db/
  livestock-infra/   <- you are here
  livestock-seed/
  ...
```

## CI

`.github/workflows/validate-migrations.yml` spins up Postgres and applies all
migrations + seed on every push, so a broken schema fails fast.

## Security note

`.env` is git-ignored and must never be committed. This repo is public — the
meeting flagged "exposing configuration files on GitHub consoles" as a critical
oversight. Use `.env.example` for documented defaults only.
