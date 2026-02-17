# E-Commerce Analytics Platform with Automated Reporting

## Overview

This project simulates a production-style e-commerce analytics environment using PostgreSQL and Bash scripting. The implementation prioritizes clarity and exam-style procedural scripting over production-level performance optimization.

The goal is to:

- Automate database creation
- Generate realistic test data
- Execute complex analytical SQL queries
- Implement reporting and maintenance workflows

The system models customers, products, suppliers, orders, order items, and reviews.

---

## Database Schema

The database includes the following tables:

- `customers`
- `suppliers`
- `products`
- `orders`
- `order_items`
- `reviews`

Each table includes:

- Primary keys
- Foreign keys
- Constraints
- Sequences
- Default values

The schema is versioned in `schema.sql`.

---

## db_setup.sh

This script performs:

1. Parameter validation
2. Database recreation (drop + create)
3. Schema deployment
4. Seed data generation (1000+ records)
5. Index creation

Usage:

```bash
chmod +x db_setup.sh
./db_setup.sh <db_name> <db_user>

Example: ./db_setup.sh ecommerce postgres
```

----

## PostgreSQL Challenges Implemented

### Complex Analytics Query

- Customer lifetime value calculation
- Ranking using window functions
- Tier categorization using `CASE`
- `COALESCE` for customers without orders

### Product Performance Report

- `LEFT JOIN` with order_items and reviews
- Nested `CASE` logic
- Supplier `INNER JOIN`
- Category-based ranking with window functions
- Sales activity evaluation

### Advanced Subquery Challenge

- Customers purchasing across 3+ categories
- Correlated subquery for above-average order value
- `NOT EXISTS` logic
- Top 20 customers by spending

### Complex UPDATE with CASE

Customer tier scoring based on:

- Recency
- Frequency
- Monetary value

### Window Function Mastery

- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LEAD()` / `LAG()`
- Moving averages
- Partitioning by category and time period

---

## Automation Components

Future scripts include:
- `daily_analytics.sh` (menu-driven reporting)
- `data_maintenance.sh` (archiving, cleanup, vacuum, maintenance reporting)

---

## Purpose of the Project

This project focuses on developing skills in:

- Schema reproducibility
- Data seeding logic
- Advanced SQL analytics
- Query performance thinking
- Script-based database orchestration
- Version-controlled infrastructure