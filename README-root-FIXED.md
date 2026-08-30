# Relational Databases & Scripting Practice

PostgreSQL practice focused on database design, automation, analytics, and Bash scripting.

The purpose of this repository is to move beyond isolated SQL exercises and work on reproducible, script-driven database environments similar to real-world backend and data workflows.

## Projects

### 1. E-Commerce Analytics Platform with Automated Reporting

A reproducible PostgreSQL environment simulating an e-commerce system.
Full documentation in [`ecommerce-analytics-platform/`](./ecommerce-analytics-platform).

| Component | Status |
|---|---|
| Automated database setup (drop / create / apply schema) | ✅ Done |
| Seed data — suppliers, customers, products | ✅ Done |
| Seed data — orders, order_items, reviews | ⬜ Planned |
| Complex analytical queries | ⬜ Planned |
| Customer segmentation logic | ⬜ Planned |
| Product performance analysis | ⬜ Planned |
| Maintenance automation | ⬜ Planned |

## Learning Objectives

These are the skills this repository is being built to develop, not a list of what it currently demonstrates:

- Relational schema design
- Automating database setup and data seeding
- Complex analytical queries, window functions, subqueries
- Maintenance and reporting scripts
- Bash scripting
- Version-controlled database infrastructure

## Technologies

PostgreSQL 18 · Bash · Git

## Repository Philosophy

- **Reproducibility** — any environment can be rebuilt from scratch with one command
- **Fail fast, fail loud** — scripts abort on the first error rather than continuing against a broken database
- **Automation over manual setup** — no "run these steps by hand" instructions
- **Version-controlled infrastructure** — the database is defined in files, not in someone's terminal history

## Known Limitations

Tracked openly rather than left for a reader to discover:

- `schema.sql` is currently a `pg_dump` snapshot, not hand-written DDL. It hardcodes object ownership and uses psql meta-commands that require a recent client. Replacing it with portable, hand-written `CREATE TABLE` statements is a planned task.
- Seed data is generated one row per `psql` invocation, which is fine at practice scale but does not represent how bulk loading should be done. A `generate_series` rewrite is planned.
- No indexes beyond those implied by primary key and unique constraints. Foreign key columns are currently unindexed.
- No automated tests.
