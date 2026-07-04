# Airbnb Data Pipeline - dbt Project

This is my end-to-end **Analytics Engineering** project built with **dbt** on Snowflake. I took raw Airbnb booking, listing, and host data and transformed it into a clean, analytics-ready **Star Schema** that business teams can actually use.

---

## The Problem

Airbnb has tons of data about bookings, listings, and hosts — but it's scattered across different tables. Analysts were spending too much time doing complex joins and fixing data issues every time they needed a report. This slowed down decision-making around revenue, cancellations, and host performance.

---

## What I Built

I designed and implemented a complete **modern data pipeline** using the **Medallion Architecture** (Bronze → Silver → Gold):

- **Bronze Layer**: Raw data loaded incrementally
- **Silver Layer**: Cleaned, standardized, and tested data
- **Gold Layer**: 
  - One Big Table (for testing)
  - Ephemeral models for intermediate logic
  - Star Schema with Fact and Dimension tables
  - Snapshots (SCD Type 2) for tracking changes over time

The final result is a clean, well-documented data model that makes analysis fast and reliable.

---

## Business Value

This project enables:
- Faster reporting on revenue, occupancy, and cancellation trends
- Better understanding of host performance and guest behavior
- Self-service analytics for Marketing, Finance, and Operations teams
- Scalable foundation for future business questions

---

## Tech Stack

- **dbt Core** (v1.11)
- **Snowflake**
- SQL + Jinja
- Git & GitHub

---

## Project Structure
