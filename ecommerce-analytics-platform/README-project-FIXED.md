# E-Commerce Analytics Platform with Automated Reporting

## Overview

A reproducible PostgreSQL environment that models an e-commerce system — customers, suppliers, products, orders, order items, and reviews — built with PostgreSQL and Bash.

The implementation prioritizes clarity and freeCodeCamp exam-style procedural scripting rather than production-level performance optimization. This is a deliberate tradeoff; see [Known Limitations](#known-limitations).

## Current State

| Component | Status |
|---|---|
| Schema (6 tables, PKs, FKs, CHECK constraints) | ✅ Done |
| `db_setup.sh` — validation, teardown, schema deployment | ✅ Done |
| Seed data — 15 suppliers, 75 customers, 100 products | ✅ Done |
| Seed data — orders, order_items, reviews | ⬜ Planned |
| Analytical query set | ⬜ Planned |
| `daily_analytics.sh` — menu-driven reporting | ⬜ Planned |
| `data_maintenance.sh` — archiving, cleanup, vacuum | ⬜ Planned |
| Indexes on foreign key columns | ⬜ Planned |

## Usage

```bash
chmod +x db_setup.sh
./db_setup.sh <db_name> <db_user>

# Example
./db_setup.sh ecommerce postgres
```

> **Note:** `schema.sql` currently hardcodes `postgres` as the object owner, so passing a different `<db_user>` will fail. Fixing this is tracked below.

## Database Schema

Six tables, versioned in `schema.sql`:

| Table | Notes |
|---|---|
| `customers` | Unique email, tier assigned later by segmentation logic |
| `suppliers` | `reliability_score` constrained to 0–5 |
| `products` | FK to `suppliers`; price and stock constrained non-negative |
| `orders` | FK to `customers`; `total_amount` constrained non-negative |
| `order_items` | FK to `orders` and `products`; quantity and unit price constrained non-negative |
| `reviews` | FK to `products` and `customers`; rating constrained 1–5 |

Every table has a primary key backed by a sequence. Foreign keys are defined wherever a relationship exists. Domain invariants are enforced by `CHECK` constraints in the database rather than in application code, so invalid data cannot be written by any client.

## Failure Handling

The setup script is written to fail fast and fail loudly rather than leave a half-built database behind:

- **`set -e`** — the script aborts on the first failing command.
- **`-v ON_ERROR_STOP=1` on every `psql` call** — required in addition to `set -e`, because `psql` exits `0` even when the SQL inside it fails. Without this flag, `set -e` would not catch a failed statement and the script would continue against a broken database.
- **`psql -X`** — ignores `~/.psqlrc`, so the script behaves identically regardless of local client configuration.
- **Connection termination before teardown** — `dropdb` fails if any session is attached to the target database. The script clears them via `pg_terminate_backend` against `pg_stat_activity`, excluding its own backend with `pid <> pg_backend_pid()` so it does not kill the connection running the statement.
- **Parameter validation** — missing arguments produce a usage message and exit `1`.

## Analytical Query Roadmap

None of the following are committed yet. They are the intended scope of the next phase, listed here as a plan rather than as delivered work.

**Customer lifetime value** — aggregate spend per customer, ranked with window functions, tier assignment via `CASE`, `COALESCE` for customers with no orders.

**Product performance report** — `LEFT JOIN` against `order_items` and `reviews`, `INNER JOIN` to suppliers, nested `CASE` logic, category-based ranking.

**Advanced subqueries** — customers purchasing across three or more categories, correlated subquery for above-average order value, `NOT EXISTS` logic, top 20 customers by spend.

**Segmentation `UPDATE`** — customer tier scoring on recency, frequency, and monetary value.

**Window functions** — `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LEAD`/`LAG`, moving averages, partitioning by category and time period.

## Known Limitations

- **`schema.sql` is a `pg_dump`, not hand-written DDL.** It contains `\restrict` psql meta-commands that require a recent client, session-level `SET` statements, and `OWNER TO postgres` on every object — which is why the `<db_user>` parameter does not currently work as documented. Replacing this with portable `CREATE TABLE` statements using `GENERATED ALWAYS AS IDENTITY` is the top open task.
- **Seeding opens one connection per row.** Each insert spawns a separate `psql` process, meaning a new TCP connection, authentication, transaction, and commit. Each row is also its own transaction, so an interrupted run leaves partially seeded data. A single `generate_series` insert per table would fix both.
- **Foreign key columns are unindexed.** PostgreSQL indexes primary keys and unique constraints automatically but not foreign keys, so joins on `order_items.order_id`, `order_items.product_id`, and `orders.customer_id` will fall back to sequential scans at scale.
- **No automated tests.**
