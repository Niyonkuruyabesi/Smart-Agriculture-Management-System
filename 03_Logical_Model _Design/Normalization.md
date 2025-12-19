# Normalization (Up to 3NF)

The database design for the **IoT-Based Smart Agriculture Management System** follows standard normalization rules to ensure data integrity, eliminate redundancy, and support scalability.

---

## First Normal Form (1NF)

The database satisfies **First Normal Form (1NF)** by ensuring that:

- There are **no repeating groups** or multi-valued attributes in any table.
- All attributes store **atomic (indivisible) values**.
- Each table has a clearly defined **Primary Key (PK)** that uniquely identifies each record.

---

## Second Normal Form (2NF)

The database satisfies **Second Normal Form (2NF)** by ensuring that:

- There are **no partial dependencies** on composite primary keys.
- All non-key attributes are **fully functionally dependent** on the entire primary key.
- Tables that record transactional or historical data (such as sensor readings and livestock tracking) use **single-column primary keys**, eliminating partial dependency risks.

---

## Third Normal Form (3NF)

The database satisfies **Third Normal Form (3NF)** by ensuring that:

- There are **no transitive dependencies** between non-key attributes.
- All non-key attributes depend **only on the primary key** and not on other non-key attributes.
- Reference data such as farms, sensors, livestock, and crop fields are stored in **separate, related tables**, improving data consistency and maintainability.

---

## Normalization Summary

The logical data model is fully normalized up to **Third Normal Form (3NF)**, providing:

- Reduced data redundancy
- Improved data integrity
- Easier maintenance and scalability
- Strong support for PL/SQL automation and Business Intelligence analysis
