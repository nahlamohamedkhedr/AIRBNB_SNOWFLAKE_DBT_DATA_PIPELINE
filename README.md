# Airbnb Data Pipeline — dbt on Snowflake

![dbt](https://img.shields.io/badge/dbt--core-1.11-orange)
![Snowflake](https://img.shields.io/badge/warehouse-Snowflake-29B5E8)
![Source](https://img.shields.io/badge/source-AWS%20S3-yellow)

An end-to-end analytics engineering project that transforms raw Airbnb booking, listing, and host data into a governed, tested, business-ready star schema — built with **dbt Core** on **Snowflake**, following the **Medallion (Bronze → Silver → Gold) architecture**.

---

## Problem statement

Airbnb's operations, marketing, and finance teams needed fast, reliable answers to core business questions — which markets and property types drive the most revenue, how host quality (superhost status, responsiveness) correlates with booking value, and how demand shifts seasonally — but the underlying data lived as disconnected raw extracts in S3 with no shared, tested data model. Every question required analysts to manually reconcile booking, listing, and host files, producing slow, inconsistent, and error-prone reporting.

## Solution

A single source of truth: a tested, version-controlled transformation layer between raw storage and the tools analysts already use, built on the medallion architecture.

| Layer | Purpose |
|---|---|
| **Bronze** | Raw data loaded incrementally from AWS S3 (via a staging schema) into Snowflake, preserving source fidelity |
| **Silver** | Cleaned, standardized, deduplicated, and incrementally maintained data |
| **Gold** | Business-ready star schema: a fact table of measurable events plus conformed dimensions, with full change history where the business needs it |

## Architecture

```
AWS S3 → Staging → Bronze (incremental)
                        │
                        ▼
                    Silver (incremental, cleaned & typed)
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
        snapshot_listings   snapshot_hosts
            (SCD2)              (SCD2)
              │                   │
              ▼                   ▼
        dim_listings         dim_hosts
        (SCD Type 1 —        (SCD Type 2 —
        current state)       full history)
              │                   │
              └─────────┬─────────┘
                         │
                    fact_bookings   ◄── dim_date
                (FKs + measures)
```

## Data model

- **`fact_bookings`** — one row per booking. Contains foreign keys (`listing_id`, `host_id`, `date_id`) and measures only (`total_booking_amount`, `service_fee`, `cleaning_fee`, `price_per_night`, `accommodates`, `bedrooms`, `bathrooms`, `response_rate`). No dimension attributes are duplicated into the fact — joins happen at query time, not build time.
- **`dim_listings`** — SCD Type 1 (current state only). Listing attributes rarely change in ways that matter to this business case, so history isn't tracked.
- **`dim_hosts`** — SCD Type 2 (full history via `dbt snapshot`). Host status (superhost, response rate tier) changes over time, and answering "did superhosts already out-earn others before earning the badge?" requires knowing a host's status *as of the booking date*, not today.
- **`dim_date`** — standard date dimension (2018–2027) generated natively in Snowflake, plus a `9999-12-31` sentinel row so any missing/invalid booking date still resolves to a valid foreign key instead of breaking referential integrity.


## Business value

- **One tested source of truth** — `fact_bookings` plus conformed dimensions replace ad hoc joins across teams
- **Self-service analytics** — analysts query a simple star schema instead of raw, scattered extracts
- **Data quality guarantees** — `unique`, `not_null`, and `relationships` tests catch duplication or orphaned keys before they reach a dashboard (a real fan-out bug was caught and fixed this way during development)
- **Scalable foundation** — modular bronze/silver/gold layers allow new sources (reviews, pricing history) to be added without re-architecting

## Tech stack

- **dbt Core** 1.11
- **Snowflake**
- **AWS S3** (raw source)
- **SQL + Jinja**
- **Git / GitHub**

## Project structure

```
├── models
│   ├── bronze/
│   │   ├── bronze_bookings.sql      # incremental
│   │   ├── bronze_listings.sql      # incremental
│   │   └── bronze_hosts.sql         # incremental
│   ├── silver/
│   │   ├── silver_bookings.sql      # incremental, unique_key=booking_id
│   │   ├── silver_listings.sql      # incremental, unique_key=listing_id
│   │   └── silver_hosts.sql         # incremental, unique_key=host_id
│   └── gold/
│       ├── dim_listings.sql         # table, SCD Type 1
│       ├── dim_hosts.sql            # table, SCD Type 2
│       ├── dim_date.sql             # table, native Snowflake date spine
│       ├── fact_bookings.sql        # table, FKs + measures 
│       └── schema.yml               # tests & documentation
├── snapshots/
│   ├── snapshot_listings.sql        # SCD2 source for dim_listings
│   └── snapshot_hosts.sql           # SCD2 source for dim_hosts
├── analyses/
│   └── explore.sql   # just data exploration
├── macros/
│       ├── generate_schema_name.sql             
│       ├── multiply.sql
│       ├── tag.sql                 
│       └── trimmer.sql               
├── seeds/
├── dbt_project.yml
└── README.md
```

## Materialization choices, and why

| Model | Materialization | Why |
|---|---|---|
| Bronze | `incremental` | Source grows continuously; full reprocessing would get expensive over time |
| Silver | `incremental` | Same reasoning — cleaned data still scales with the raw source |
| Gold dimensions (`dim_listings`, `dim_hosts`, `dim_date`) | `table` | Small (hundreds to a few thousand rows); a full rebuild costs a fraction of a second, so incremental's added complexity (merge logic, unique keys, backfill edge cases) isn't worth it here |
| `fact_bookings` | `table` | Same reasoning at current scale; revisit as `incremental` if booking volume grows into the millions |

## Testing & data quality

- Generic tests (`unique`, `not_null`, `relationships`) on every gold model, defined in `schema.yml`
- `relationships` tests enforce referential integrity between `fact_bookings` and every dimension
- A real grain bug (dimensions fanning out to booking-level row counts instead of their true cardinality) was caught by these tests during development and traced back to snapshotting from the wrong source layer — fixed by snapshotting `silver_listings`/`silver_hosts` instead of the OBT
