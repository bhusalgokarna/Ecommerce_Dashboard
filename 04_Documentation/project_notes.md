# Olist E-Commerce Intelligence Dashboard
## Complete Project Guidance Book
### Power BI · Power Query (M Language) · DAX · Power Automate

---

> **Dataset:** Olist Brazilian E-Commerce (Kaggle)  
> **Tool Stack:** Power BI Desktop · Power Query · DAX · Power Automate  
> **Skill Level:** Intermediate  
> **Project Type:** End-to-end BI pipeline with automation  

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Key Definitions](#2-key-definitions)
3. [Phase 1 — Data Sourcing & Project Setup](#3-phase-1--data-sourcing--project-setup)
4. [Phase 2 — Power Query & M Language (ETL)](#4-phase-2--power-query--m-language-etl)
5. [Phase 3 — Data Modelling & Star Schema](#5-phase-3--data-modelling--star-schema)
6. [Phase 4 — DAX Mastery](#6-phase-4--dax-mastery)
7. [Phase 5 — Dashboard Design & Storytelling](#7-phase-5--dashboard-design--storytelling)
8. [Phase 6 — Publishing to Power BI Service](#8-phase-6--publishing-to-power-bi-service)
9. [Phase 7 — Power Automate & Automation](#9-phase-7--power-automate--automation)
10. [Project Summary & Key Metrics](#10-project-summary--key-metrics)
11. [Lessons Learned & Real-World Fixes](#11-lessons-learned--real-world-fixes)
12. [DAX Measures Reference](#12-dax-measures-reference)
13. [M Language Reference](#13-m-language-reference)
14. [Power Automate Flows Reference](#14-power-automate-flows-reference)

---

## 1. Project Overview

### What We Built
A complete, professional **Sales & Operations Intelligence Dashboard** built on real e-commerce transaction data. The project covers every layer of a professional BI pipeline — from raw CSV ingestion to automated weekly reporting.

### Business Questions Answered
- How is overall revenue trending over time?
- What is our on-time delivery performance?
- Which product categories generate the most revenue?
- Which categories have the lowest customer satisfaction?
- Where are our customers geographically concentrated?
- How do customers prefer to pay?
- Are we improving or declining year over year?

### Final Deliverables
```
📁 ECommerce_BI_Project
├── 📁 01_Raw_Data                  ← 9 original CSV files (never modified)
├── 📁 02_Processed_Data            ← cleaned exports
├── 📁 03_PowerBI
│   └── Olist_Ecommerce_Dashboard_v1.pbix
├── 📁 04_Documentation
│   └── project_notes.md            ← this file
└── 📁 05_Exports                   ← screenshots, PDFs
```

### Key Metrics at a Glance
| Metric | Value |
|---|---|
| Total Revenue | R$ 13,591,643.70 |
| Total Orders | 99,440 |
| On Time Delivery Rate | 89.1% |
| Late Delivery Rate | 7.9% |
| Avg Review Score | 4.09 / 5 |
| Worst Reviewed Category | Security & Services (2.5) |
| Best Reviewed Category | CD DVDs Musicals (4.67) |
| Date Range | September 2016 – October 2018 |

---

## 2. Key Definitions

### General BI Terms

**ETL (Extract, Transform, Load)**
The three-step process of pulling raw data from a source, cleaning and shaping it, and loading it into a data model. In this project: CSV files → Power Query → Power BI data model.

**Star Schema**
The standard way to structure a Power BI data model. One or more fact tables sit at the centre, surrounded by dimension tables. Named after its star-like visual appearance. DAX was designed to work on star schemas.

**Fact Table**
A table containing measurable business events — transactions, orders, payments. Has many rows and connects to multiple dimension tables via foreign keys. Example: `Order_Items`.

**Dimension Table**
A table describing the context of facts — who, what, where, when. Has fewer rows and one unique key per row. Examples: `Customers`, `Products`, `Date_Table`.

**Cardinality**
Describes how rows relate between two tables in a relationship:
- **One-to-Many (1:*)** — one row in the dimension matches many rows in the fact. Standard relationship type.
- **Many-to-Many (*:*)** — avoid. Causes incorrect totals and ambiguous filtering.

**Filter Direction**
The direction filters flow between related tables:
- **Single** — filters flow from the one-side (dimension) to the many-side (fact). Always the default.
- **Both** — filters flow both ways. Avoid unless strictly necessary.

**Filter Context**
The set of filters active when a DAX measure evaluates. Changes per row, per visual, per slicer selection. The most important concept in DAX.

**Grain**
The level of detail represented by one row in a table. Example: `Order_Items` grain = one row per order line item, not one row per order.

**Data Profiling**
The act of inspecting raw data before transforming it — understanding row counts, date ranges, null values, data types, and distinct values.

---

### Power Query / M Language Terms

**Power Query**
Power BI's built-in ETL engine. Every transformation applied through the visual interface generates M language code behind the scenes. All transformations are reproducible and auditable.

**M Language**
The functional, step-chained language that Power Query runs on. Each step takes the result of the previous step as input. Steps are defined inside a `let...in` block.

**Applied Steps**
The panel in Power Query Editor that records every transformation as a named step. Each step is clickable — clicking a step shows the state of the data at that exact point.

**Query Folding**
When Power Query pushes transformation logic back to the data source (e.g. SQL server) rather than processing it locally. Improves performance. Not applicable to CSV sources.

**Left Outer Join (Merge)**
A join that keeps all rows from the left table and matches rows from the right table where a key column matches. Used in this project to merge `Products` with `Category_Translation`.

---

### DAX Terms

**DAX (Data Analysis Expressions)**
The formula language of Power BI. Used to create calculated columns and measures. Evaluates dynamically based on filter context.

**Measure**
A DAX formula that calculates dynamically based on the current filter context. Not stored in the table — computed on the fly. Best practice: store all measures in a dedicated `_Measures` table.

**Calculated Column**
A DAX formula evaluated row by row and stored in the table at refresh time. Use sparingly — consumes memory. Prefer measures for aggregations.

**CALCULATE**
The most important DAX function. Evaluates an expression while modifying the filter context.
```
CALCULATE(<expression>, <filter1>, <filter2>)
```

**SUMX / COUNTX / AVERAGEX**
Iterator functions. Evaluate an expression row by row over a table, then aggregate. More flexible than SUM/COUNT/AVERAGE.

**DIVIDE**
Safe division function. Returns a specified alternate result (default 0) instead of an error when the denominator is zero.
```
DIVIDE(<numerator>, <denominator>, <alternate_result>)
```

**TREATAS**
Maps a filter from one table onto another, bypassing the relationship path. Used to fix broken filter chains across multiple table hops.

**Time Intelligence**
A family of DAX functions that perform date-based calculations. Require a properly marked Date Table with a continuous, gap-free date column.
- `TOTALYTD` — year-to-date total
- `TOTALMTD` — month-to-date total
- `SAMEPERIODLASTYEAR` — same period in the previous year

**Measure Branching**
Building complex measures by referencing simpler measures. Avoids repeating logic. Example: `[Total Revenue incl. Freight] = [Total Revenue] + [Total Freight]`.

---

### Power Automate Terms

**Flow**
An automated workflow in Power Automate. Consists of a trigger and one or more actions.

**Trigger**
The event that starts a flow. Can be scheduled (time-based), automated (event-based), or instant (manually run).

**Action**
A step within a flow that does something — sends an email, runs a query, parses data, evaluates a condition.

**Condition**
A control step that branches a flow into Yes/No paths based on a logical evaluation.

**Compose**
A utility action that stores a value or expression for reuse in later steps.

**Parse JSON**
An action that reads a JSON response and extracts structured data from it. Required when consuming API responses like Power BI query results.

**Dynamic Content**
Values from previous steps in the flow, inserted into later steps. Selected from the Dynamic Content panel that appears when clicking inside a field.

**Expression**
A formula written in Power Automate's expression language. Used for calculations, string manipulation, and JSON path navigation. Example: `utcNow()`, `mul()`, `body('Step_Name')?['key']`.

---

## 3. Phase 1 — Data Sourcing & Project Setup

### Dataset
**Olist Brazilian E-Commerce Dataset**  
Source: `https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce`  
Format: 9 CSV files  
Total orders: 99,441  
Date range: September 2016 – October 2018  

### The 9 CSV Files
| File | Renamed To | Description |
|---|---|---|
| `olist_orders_dataset.csv` | `Orders` | Master order records |
| `olist_order_items_dataset.csv` | `Order_Items` | Line items per order |
| `olist_customers_dataset.csv` | `Customers` | Customer records |
| `olist_products_dataset.csv` | `Products` | Product catalogue |
| `olist_sellers_dataset.csv` | `Sellers` | Seller records |
| `olist_order_payments_dataset.csv` | `Payments` | Payment records |
| `olist_order_reviews_dataset.csv` | `Reviews` | Customer reviews |
| `olist_geolocation_dataset.csv` | `Geolocation` | Zip code coordinates |
| `product_category_name_translation.csv` | `Category_Translation` | Portuguese to English |

### Project Folder Structure
```
📁 ECommerce_BI_Project
├── 📁 01_Raw_Data          ← paste all CSVs here, NEVER edit them
├── 📁 02_Processed_Data    ← cleaned exports go here later
├── 📁 03_PowerBI           ← your .pbix file lives here
├── 📁 04_Documentation     ← notes, data dictionary, business questions
└── 📁 05_Exports           ← screenshots, PDFs of finished dashboard
```

> **Golden Rule:** The `01_Raw_Data` folder is sacred. Never modify original files. All cleaning happens inside Power Query.

### Data Profiling Findings
| Table | Key Finding |
|---|---|
| `Orders` | 99,441 rows. No nulls in `order_status`. Has nulls in `order_delivered_customer_date` for undelivered orders |
| `Order_Items` | Grain = one row per line item (multiple rows per order_id) |
| `Customers` | `customer_id` unique per row. Clean dimension |
| `Products` | Has blank `product_category_name` values — needs fixing in Power Query |

### Column Profiling Setting — Important
> By default Power Query profiles only the **top 1,000 rows**. Always switch to **"Column profiling based on entire data set"** for accurate counts. Click the text at the bottom left of the Power Query Editor screen.

---

## 4. Phase 2 — Power Query & M Language (ETL)

### How to Open Power Query Editor
`Home → Get Data → Text/CSV → select file → Transform Data`  
**Never click Load directly** — always click Transform Data to open the editor first.

### The Power Query Editor Interface
```
┌─────────────────────────────────────────────────────┐
│  LEFT PANEL      │  CENTER (data preview)            │
│  Queries list    │  Your table rows and columns      │
│  (all tables)    │                                   │
├──────────────────┴───────────────────────────────────┤
│  RIGHT PANEL — Applied Steps                         │
│  Every transformation recorded here, in order        │
└─────────────────────────────────────────────────────┘
```

### Transformations Applied Per Table

#### Orders Table
- Set data types: `order_purchase_timestamp`, `order_delivered_customer_date`, `order_estimated_delivery_date` → **Date/Time**
- Removed columns: `order_approved_at`, `order_delivered_carrier_date`
- Added `Delivery_Days` column (null-safe):
```
= if [order_delivered_customer_date] = null 
  then null 
  else Duration.Days([order_delivered_customer_date] - [order_purchase_timestamp])
```
- Added `Delivery_Status` column (three-way logic):
```
= if [order_delivered_customer_date] = null then "Not Delivered"
  else if [order_delivered_customer_date] <= [order_estimated_delivery_date] then "On Time"
  else "Late"
```
- Added `Order_Date` column (strips time from timestamp for Date Table join):
```
= Date.From([order_purchase_timestamp])
```

> **Critical:** The `Order_Date` column (type: date) is what joins to `Date_Table[Date]`. Using `order_purchase_timestamp` (type: datetime) directly caused the Date_Table filter to break entirely.

#### Delivery Status Results
| Status | Count | % |
|---|---|---|
| On Time | 88,649 | 89.1% |
| Late | 7,827 | 7.9% |
| Not Delivered | 2,965 | 3.0% |

#### Order_Items Table
- Set data types: `price`, `freight_value` → **Decimal Number**; `shipping_limit_date` → **Date/Time**
- Added `Total_Item_Value`:
```
= [price] + [freight_value]
```

#### Payments Table
- Set data types: `payment_value` → **Decimal Number**; `payment_installments`, `payment_sequential` → **Whole Number**
- Payment type distribution (full dataset):
  - Credit Card: ~73%
  - Boleto: ~18%
  - Voucher: ~5%
  - Debit Card: ~2%

#### Customers Table
- Removed: `customer_zip_code_prefix` — **NOTE: restore this column** — needed for Geolocation relationship
- Renamed: `customer_city` → `City`, `customer_state` → `State`, `customer_unique_id` → `Unique_Customer_ID`

#### Sellers Table
- Removed: `seller_zip_code_prefix`
- Renamed: `seller_city` → `Seller_City`, `seller_state` → `Seller_State`

#### Products Table
- Replaced blank `product_category_name` values with `Unknown`
- Removed: `product_name_lenght`, `product_description_lenght`, `product_photos_qty`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm`
- Merged with `Category_Translation` via Left Outer Join on `product_category_name`
- Expanded merged column → kept only `product_category_name_english` → renamed to `Category_English`
- Replaced null `Category_English` values with `Unknown`

#### Reviews Table
- Kept only: `review_id`, `order_id`, `review_score`
- Set `review_score` → **Whole Number**

#### Geolocation Table
- Removed duplicates on `geolocation_zip_code_prefix`
- Renamed columns: `Zip_Prefix`, `Latitude`, `Longitude`, `City`, `State`

### Date Table — Built from Scratch in M Language

**How to create:** Power Query Editor → `Home → New Source → Blank Query` → rename to `Date_Table` → `View → Advanced Editor` → paste code below.

```m
let
    StartDate = #date(2016, 1, 1),
    EndDate   = #date(2018, 12, 31),
    NumberOfDays = Duration.Days(EndDate - StartDate),
    DateList = List.Dates(StartDate, NumberOfDays + 1, #duration(1, 0, 0, 0)),
    TableFromList = Table.FromList(DateList, Splitter.SplitByNothing()),
    RenamedColumn = Table.RenameColumns(TableFromList, {{"Column1", "Date"}}),
    ChangedType = Table.TransformColumnTypes(RenamedColumn, {{"Date", type date}}),
    AddedYear = Table.AddColumn(ChangedType, "Year", each Date.Year([Date]), Int64.Type),
    AddedMonthNum = Table.AddColumn(AddedYear, "Month_Number", each Date.Month([Date]), Int64.Type),
    AddedMonthName = Table.AddColumn(AddedMonthNum, "Month_Name", each Date.ToText([Date], "MMMM"), type text),
    AddedQuarter = Table.AddColumn(AddedMonthName, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    AddedWeekNum = Table.AddColumn(AddedQuarter, "Week_Number", each Date.WeekOfYear([Date]), Int64.Type),
    AddedDayName = Table.AddColumn(AddedWeekNum, "Day_Name", each Date.ToText([Date], "dddd"), type text),
    AddedYearMonth = Table.AddColumn(AddedDayName, "Year_Month", each Text.From(Date.Year([Date])) & "-" & Text.PadStart(Text.From(Date.Month([Date])), 2, "0"), type text)
in
    AddedYearMonth
```

**Result:** 1,096 rows (3 years × 365 days + 1 leap day for 2016)

### Key M Language Pattern — Null Safety
Always null-check before any calculation involving a nullable column:
```
= if [column] = null then <safe_value> else <real_calculation>
```

### Final Step — Close & Apply
`Home → Close & Apply` — loads all 9 tables into the data model.

---

## 5. Phase 3 — Data Modelling & Star Schema

### Table Roles
| Table | Role | Primary Key |
|---|---|---|
| `Order_Items` | ⭐ Primary Fact | `order_id`, `product_id`, `seller_id` |
| `Orders` | ⭐ Secondary Fact | `order_id`, `customer_id` |
| `Payments` | ⭐ Secondary Fact | `order_id` |
| `Reviews` | ⭐ Secondary Fact | `order_id` |
| `Customers` | 📋 Dimension | `customer_id` |
| `Products` | 📋 Dimension | `product_id` |
| `Sellers` | 📋 Dimension | `seller_id` |
| `Date_Table` | 📋 Dimension | `Date` |
| `Geolocation` | 📋 Dimension | `Zip_Prefix` |

### All 8 Relationships
| From | To | Column | Cardinality | Filter Direction |
|---|---|---|---|---|
| `Orders` | `Customers` | `customer_id` | Many to One | Single |
| `Order_Items` | `Orders` | `order_id` | Many to One | Single |
| `Order_Items` | `Products` | `product_id` | Many to One | Single |
| `Order_Items` | `Sellers` | `seller_id` | Many to One | Single |
| `Payments` | `Orders` | `order_id` | Many to One | Single |
| `Reviews` | `Orders` | `order_id` | Many to One | Single |
| `Date_Table` | `Orders` | `Date` → `Order_Date` | One to Many | Single |
| `Customers` | `Geolocation` | `customer_zip_code_prefix` → `Zip_Prefix` | Many to One | Single |

> **Critical:** Delete all auto-detected relationships first. Build every relationship manually to ensure correctness.

### How to Build a Relationship
1. Go to **Model View** (left sidebar)
2. Drag the key column from one table to the matching column in another
3. Double-click the relationship line to verify cardinality and filter direction
4. Confirm: solid line (not dashed), correct cardinality icons (1 and *)

### Mark Date Table
`Model View → click Date_Table → Table Tools → Mark as Date Table → select Date column → OK`

This is **mandatory** for all time intelligence DAX functions to work correctly.

### Star Schema Diagram
```
                    📅 Date_Table
                         │
         👤 Customers ───┤
                         │
         📦 Products ────┼──── 🧾 Order_Items (PRIMARY FACT)
                         │              │
         🏪 Sellers ─────┤              │
                         │         🧾 Orders (SECONDARY FACT)
         📍 Geolocation──┘              │
                                   💳 Payments
                                   ⭐ Reviews
```

---

## 6. Phase 4 — DAX Mastery

### Best Practice — Measures Table
Before writing any measure:
1. `Home → Enter Data → Load` (create empty table)
2. Rename it `_Measures` (underscore sorts it to the top)
3. Store ALL measures here — never scatter them across fact tables

### All 17 Measures

#### Revenue Measures
```dax
Total Revenue =
SUMX(Order_Items, Order_Items[price])

Total Freight =
SUMX(Order_Items, Order_Items[freight_value])

Total Revenue incl. Freight =
[Total Revenue] + [Total Freight]

Avg Order Value =
DIVIDE([Total Revenue], [Total Orders], 0)
```

#### Volume Measures
```dax
Total Orders =
DISTINCTCOUNT(Orders[order_id])

Total Items Sold =
COUNTROWS(Order_Items)
```

#### Customer Measures
```dax
Total Customers =
DISTINCTCOUNT(Customers[customer_id])

Revenue per Customer =
DIVIDE([Total Revenue], [Total Customers], 0)
```

#### Delivery Performance Measures
```dax
On Time Delivery Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Orders), Orders[Delivery_Status] = "On Time"),
    [Total Orders], 0
)

Late Delivery Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Orders), Orders[Delivery_Status] = "Late"),
    [Total Orders], 0
)

Avg Delivery Days =
AVERAGE(Orders[Delivery_Days])
```

#### Review Measures
```dax
-- Use VAR bridge to fix filter chain across 3 table hops
Avg Review Score =
VAR FilteredOrders =
    CALCULATETABLE(
        DISTINCT(Orders[order_id]),
        RELATEDTABLE(Order_Items)
    )
RETURN
CALCULATE(
    AVERAGE(Reviews[review_score]),
    FilteredOrders
)

Total Reviews =
COUNTROWS(Reviews)
```

#### Time Intelligence Measures
```dax
Revenue LY =
CALCULATE([Total Revenue], SAMEPERIODLASTYEAR(Date_Table[Date]))

Revenue YTD =
TOTALYTD([Total Revenue], Date_Table[Date])

Revenue MTD =
TOTALMTD([Total Revenue], Date_Table[Date])

Revenue YoY % =
DIVIDE([Total Revenue] - [Revenue LY], [Revenue LY], 0)
```

### Measure Formatting Guide
| Measure | Format |
|---|---|
| Revenue measures | Currency, 2 decimal places |
| Rate / percentage measures | Percentage, 1 decimal place |
| Avg Delivery Days | Decimal, 1 decimal place |
| Avg Review Score | Decimal, 2 decimal places |
| Count measures | Whole number |

### The CALCULATE Pattern — Memorise This
```dax
Measure =
CALCULATE(
    <expression>,     -- what to calculate
    <filter 1>,       -- context modifier
    <filter 2>        -- optional additional filter
)
```

### Filter Chain Rule
> If a measure lives on one end of the model and the filter comes from the other end across more than two tables — verify it works. If not, use TREATAS or a VAR bridge to explicitly bridge the gap.

---

## 7. Phase 5 — Dashboard Design & Storytelling

### Design Principles
1. **One page = one story** — each page answers one business question
2. **Most important number = top left** — human eye reads top-left first
3. **Information hierarchy:**
   - KPI Cards (what) → top of page
   - Trend Charts (when) → middle
   - Breakdown Visuals (why/where) → bottom
4. **Slicers** → always on left or top, consistent across pages
5. **Colour with purpose** — Red = bad, Green = good. One accent colour maximum

### Setup Steps
- `View → Gridlines → On`
- `View → Snap to Grid → On`
- `View → Page View → Fit to Page`
- Apply theme: `View → Themes → Browse for Themes`

### The 4 Dashboard Pages

#### Page 1 — Executive Overview
*Business question: "How is the business performing overall?"*

| Visual | Type | Fields |
|---|---|---|
| KPI Cards (×5) | Card | Total Revenue, Total Orders, Total Customers, Avg Order Value, Avg Review Score |
| Revenue Trend | Line Chart | X: `Year_Month`, Y: Total Revenue, Secondary Y: Total Orders |
| Revenue by Year | Clustered Bar | Y: Year, X: Total Revenue + Revenue LY |
| Year Slicer | Slicer (Tile) | `Date_Table[Year]` |

#### Page 2 — Delivery Performance
*Business question: "Are we delivering on time and where are we failing?"*

| Visual | Type | Fields |
|---|---|---|
| KPI Cards (×3) | Card | On Time Delivery Rate, Late Delivery Rate, Avg Delivery Days |
| Delivery Status | Donut Chart | Legend: Delivery_Status, Values: Total Orders |
| Late by State | Bar Chart | Y: State, X: Late Delivery Rate |
| Delivery Trend | Line Chart | X: Year_Month, Y: Avg Delivery Days |

**Donut colour coding:**
- On Time → Green
- Late → Red
- Not Delivered → Grey

#### Page 3 — Product & Category
*Business question: "What are we selling and what drives revenue?"*

| Visual | Type | Fields |
|---|---|---|
| Revenue by Category | Treemap | Group: Category_English, Values: Total Revenue |
| Top 10 Products | Bar Chart | Y: product_id, X: Total Revenue, Legend: Category_English |
| Review Score by Category | Bar Chart | Y: Category_English, X: Avg Review Score |

**Review score conditional formatting rules:**
- < 3 → Red
- 3 to 4 → Amber
- > 4 → Green

**Reference line on review chart:** Add constant line at 4.0 (Analytics pane → Constant Line)

**Key insight:** Check for categories that are high revenue BUT low review score — this is a critical business risk.

#### Page 4 — Customer & Geography
*Business question: "Who are our customers and where are they?"*

| Visual | Type | Fields |
|---|---|---|
| KPI Cards (×4) | Card | Total Customers, Revenue per Customer, Total Orders, Avg Order Value |
| Brazil Heatmap | Filled Map | Location: State, Color: Total Revenue |
| Revenue by State | Bar Chart | Y: State, X: Total Revenue (Top 10 filter) |
| Payment Types | Donut Chart | Legend: payment_type, Values: Total Revenue |
| Payment Instalments | Column Chart | X: payment_installments, Y: Total Orders |

> **Filled Map Fix:** `File → Options → Security → tick "Use Map and Filled Map visuals" → OK → restart Power BI`

### Polish Steps
1. **Navigation buttons** — `Insert → Buttons → Blank` → Action: Page Navigation
2. **Conditional formatting on KPI cards** — colour thresholds for rates and scores
3. **Tooltips** — add extra fields as tooltip context on key visuals
4. **Drill-through** — drag `Category_English` to Drill-through section on Page 3
5. **Hide page tabs** — right-click tab → Hide Page
6. **Title header** — consistent Text Box + colour band on all pages
7. **Alignment** — `Format → Align` and `Format → Distribute Vertically`

### How to Align Visuals
1. Select multiple visuals with **Ctrl + click**
2. Go to **Format ribbon → Align → Align Top** (for row alignment)
3. Then **Format → Distribute Vertically** (for equal spacing)

---

## 8. Phase 6 — Publishing to Power BI Service

> **Note:** Requires a work or school Microsoft account. Free developer tenant available at `https://developer.microsoft.com/en-us/microsoft-365/dev-program`

### Publishing Steps
1. Sign into Power BI Desktop with Microsoft work account (top right corner)
2. `Home → Publish → Select Workspace → Publish`
3. Open report at `https://app.powerbi.com`

### Power BI Service Concepts
- **Dataset** — the data model, relationships, and DAX measures
- **Report** — the visual pages built on top of the dataset
- **Dashboard** — a single canvas with pinned visuals from one or more reports
- **Workspace** — a cloud folder for organising content

### Pin Visuals to Dashboard
Hover over a visual in the report → click 📌 pin icon → New Dashboard → name it

### Scheduled Refresh Setup
1. Download Personal Gateway: Power BI Service → Download icon → Data Gateway → Personal Mode
2. Install and sign in with same Microsoft account
3. Go to Dataset → Settings → Scheduled Refresh → configure time and frequency

### Row Level Security (RLS)
Define in Power BI Desktop:
`Modelling → Manage Roles → Create`

Example roles:
```
São Paulo Seller:  Customers[State] = "SP"
South Region:      Customers[State] IN {"PR", "SC", "RS"}
```

Test with: `Modelling → View As → select role`  
Assign users to roles in Power BI Service after publishing.

### Capacity Limitation Note
The free Microsoft 365 Developer tenant has limited Fabric compute capacity. For heavy datasets (99,000+ rows), you may hit capacity limits when loading reports or running DAX queries via Power Automate. This is a free-tier infrastructure limitation, not a skill or configuration problem.

---

## 9. Phase 7 — Power Automate & Automation

**Access:** `https://make.powerautomate.com`  
**Account:** Same Microsoft work/school account

### Flow 1 — Daily Dashboard Refresh Notification

**Type:** Scheduled Cloud Flow  
**Schedule:** Every day at 07:00 AM (Brussels timezone)  

**Flow Structure:**
```
⏰ Recurrence — daily 7AM
      ↓
📊 Power BI — Refresh a dataset
      ↓
If SUCCESS  →  ✅ Send success email (Outlook)
If FAILED   →  ❌ Send failure alert email (Outlook)
```

**Configure run after (error handling):**
- Success email: tick `is successful` only
- Failure email: tick `has failed` only
(Click three dots `...` on step → Configure run after)

**Dynamic expression for timestamp:**
```
@{utcNow()}
```

---

### Flow 2 — Low Review Score Alert

**Type:** Scheduled Cloud Flow  
**Schedule:** Every day at 08:00 AM  

**Flow Structure:**
```
⏰ Recurrence — daily 8AM
      ↓
📊 Power BI — Run a query against dataset
   Query: EVALUATE ROW("Avg_Review_Score", [Avg Review Score])
      ↓
🔍 Parse JSON — extract score value
      ↓
❓ Condition — score < 3.5?
      ↓                    ↓
   YES                    NO
    ↓                      ↓
🚨 Send Alert Email    ✅ Send All Clear Email
```

**JSON Schema for Parse JSON:**
```json
{
  "results": [
    {
      "tables": [
        {
          "rows": [
            {
              "Avg_Review_Score": 4.09
            }
          ]
        }
      ]
    }
  ]
}
```

**Expression to extract value:**
```
body('Parse_JSON')?['results']?[0]?['tables']?[0]?['rows']?[0]?['Avg_Review_Score']
```

---

### Flow 3 — Weekly KPI Summary Email

**Type:** Scheduled Cloud Flow  
**Schedule:** Every Monday at 07:30 AM  

**Flow Structure:**
```
⏰ Recurrence — every Monday 7:30AM
      ↓
📊 Get Total Revenue     📊 Get Total Orders
      ↓                        ↓
🔍 Parse Revenue         🔍 Parse Orders
      ↓                        ↓
✏️ Compose Revenue       ✏️ Compose Orders

📊 Get Delivery Rate     📊 Get Review Score
      ↓                        ↓
🔍 Parse Delivery Rate   🔍 Parse Review Score
      ↓                        ↓
✏️ Compose Delivery Rate ✏️ Compose Review Score
      ↓
✏️ Compose Email Body
      ↓
📧 Send Email (Outlook)
```

**DAX Queries used:**
```
EVALUATE ROW("Total_Revenue", [Total Revenue])
EVALUATE ROW("Total_Orders", [Total Orders])
EVALUATE ROW("OnTime_Rate", [On Time Delivery Rate])
EVALUATE ROW("Avg_Score", [Avg Review Score])
```

**Email body (plain text version — reliable across all connector versions):**
```
📊 OLIST WEEKLY KPI REPORT
─────────────────────────────

💰 Total Revenue       R$ [Compose Revenue]
📦 Total Orders        [Compose Orders]
🚚 On Time Delivery    [Compose Delivery Rate]
⭐ Avg Review Score    [Compose Review Score] / 5

─────────────────────────────
⚠️ Watch List
Worst review category: Security & Services (2.5 / 5)

Dashboard: https://app.powerbi.com
Generated: Monday Morning Automated Report
```

> **Note on capacity:** Running DAX queries from Power Automate against a dataset on the free Microsoft 365 Developer tenant may hit Fabric compute capacity limits. On a proper Power BI Pro licence this works without restriction.

---

## 10. Project Summary & Key Metrics

### Revenue by Year
| Year | Revenue |
|---|---|
| 2016 | R$ 497,859.20 |
| 2017 | R$ 6,155,806.92 |
| 2018 | R$ 7,386,050.80 |
| **Total** | **R$ 13,591,643.70** |

### Delivery Performance
| Status | Count | % |
|---|---|---|
| On Time | 88,649 | 89.1% |
| Late | 7,827 | 7.9% |
| Not Delivered | 2,965 | 3.0% |

### Payment Methods
| Method | % Share |
|---|---|
| Credit Card | ~73% |
| Boleto | ~18% |
| Voucher | ~5% |
| Debit Card | ~2% |

### Review Score Highlights
| Category | Score |
|---|---|
| Security & Services | 2.5 ⚠️ (lowest) |
| CD DVDs Musicals | 4.67 ✅ (highest) |
| Overall Average | 4.09 |

---

## 11. Lessons Learned & Real-World Fixes

### Fix 1 — Null Delivery Dates Causing Errors
**Problem:** `Delivery_Days` and `Delivery_Status` columns threw errors because some orders had null `order_delivered_customer_date` values (undelivered orders).  
**Fix:** Added null check before calculation using the M pattern:
```
= if [column] = null then <safe_value> else <real_calculation>
```

### Fix 2 — Date vs DateTime Mismatch Breaking Time Intelligence
**Problem:** `Date_Table[Date]` is type `date`. `Orders[order_purchase_timestamp]` is type `datetime`. Power BI cannot join these types — the relationship existed visually but no filter flowed. All time intelligence measures returned wrong values.  
**Fix:** Added a new `Order_Date` column in Power Query using `Date.From([order_purchase_timestamp])` and rebuilt the relationship using this date-only column.

### Fix 3 — Review Score Filter Chain Broken
**Problem:** `Avg Review Score` returned the same value (4.9) for every product category because the filter chain `Products → Order_Items → Orders → Reviews` was too long for automatic filter propagation.  
**Fix:** Rewrote the measure using a VAR bridge that explicitly captures filtered order IDs from Order_Items and passes them to the Reviews calculation.

### Fix 4 — Filled Map Visual Disabled
**Problem:** `FilledMapVisualNotEnabled` error when trying to use the Filled Map visual.  
**Fix:** `File → Options → Security → tick "Use Map and Filled Map visuals" → OK → restart Power BI Desktop`.

### Fix 5 — Power Query Step Referencing Wrong Column Names
**Problem:** Duplicate and redundant Applied Steps from multiple type-change operations accumulated in the Orders query.  
**Fix:** Opened Advanced Editor and rewrote the complete M query cleanly from scratch, removing empty filter steps and duplicate type change steps.

### Fix 6 — Power Automate Compose Reference Errors
**Problem:** `invalid reference to 'Compose_Orders'` error because internal step names in Power Automate differ from display names when steps are renamed.  
**Fix:** Always insert dynamic values using the **Dynamic Content panel** rather than typing expressions manually — Power Automate resolves internal names automatically.

---

## 12. DAX Measures Reference

| Measure | Table | Category |
|---|---|---|
| `Total Revenue` | `_Measures` | Revenue |
| `Total Freight` | `_Measures` | Revenue |
| `Total Revenue incl. Freight` | `_Measures` | Revenue |
| `Avg Order Value` | `_Measures` | Revenue |
| `Total Orders` | `_Measures` | Volume |
| `Total Items Sold` | `_Measures` | Volume |
| `Total Customers` | `_Measures` | Customers |
| `Revenue per Customer` | `_Measures` | Customers |
| `On Time Delivery Rate` | `_Measures` | Delivery |
| `Late Delivery Rate` | `_Measures` | Delivery |
| `Avg Delivery Days` | `_Measures` | Delivery |
| `Avg Review Score` | `_Measures` | Satisfaction |
| `Total Reviews` | `_Measures` | Satisfaction |
| `Revenue LY` | `_Measures` | Time Intelligence |
| `Revenue YTD` | `_Measures` | Time Intelligence |
| `Revenue MTD` | `_Measures` | Time Intelligence |
| `Revenue YoY %` | `_Measures` | Time Intelligence |

---

## 13. M Language Reference

### Key Functions Used in This Project

| Function | What It Does | Example |
|---|---|---|
| `Date.From()` | Converts DateTime to Date | `Date.From([order_purchase_timestamp])` |
| `Date.Year()` | Extracts year from a date | `Date.Year([Date])` |
| `Date.Month()` | Extracts month number | `Date.Month([Date])` |
| `Date.ToText()` | Formats date as text | `Date.ToText([Date], "MMMM")` |
| `Date.QuarterOfYear()` | Returns quarter number (1-4) | `Date.QuarterOfYear([Date])` |
| `Date.WeekOfYear()` | Returns week number | `Date.WeekOfYear([Date])` |
| `Duration.Days()` | Days between two dates | `Duration.Days([end] - [start])` |
| `List.Dates()` | Generates a list of dates | `List.Dates(start, count, increment)` |
| `Table.AddColumn()` | Adds a calculated column | `Table.AddColumn(prev, "Name", each ...)` |
| `Table.RemoveColumns()` | Removes columns | `Table.RemoveColumns(prev, {"col1", "col2"})` |
| `Table.RenameColumns()` | Renames columns | `Table.RenameColumns(prev, {{"old", "new"}})` |
| `Table.TransformColumnTypes()` | Sets data types | `Table.TransformColumnTypes(prev, {{"col", type date}})` |
| `Text.PadStart()` | Pads text to fixed length | `Text.PadStart("3", 2, "0")` → `"03"` |
| `Text.From()` | Converts number to text | `Text.From(2017)` → `"2017"` |

### M Language Structure
```m
let
    Step1 = <expression>,
    Step2 = <expression using Step1>,
    Step3 = <expression using Step2>
in
    Step3   -- the final step is what gets returned
```

---

## 14. Power Automate Flows Reference

### Flow Summary
| Flow | Schedule | Purpose | Status |
|---|---|---|---|
| Olist — Daily Dashboard Refresh | Daily 07:00 AM | Refreshes dataset, confirms via email | ✅ Active |
| Olist — Review Score Monitor | Daily 08:00 AM | Alerts if avg score drops below 3.5 | ✅ Active |
| Olist — Weekly KPI Summary | Every Monday 07:30 AM | Sends weekly KPI report email | ✅ Active |

### Power Automate Expression Quick Reference
| Expression | What It Does |
|---|---|
| `@{utcNow()}` | Current UTC timestamp |
| `@{utcNow('dd MMM yyyy')}` | Formatted date e.g. "16 Jun 2026" |
| `mul(value, 100)` | Multiplies value by 100 (for % display) |
| `body('Step_Name')` | Gets the output body of a named step |
| `?['key']` | Safely accesses a JSON key (null-safe) |
| `?[0]` | Accesses first element of a JSON array |

---

*Document generated: June 2026*  
*Project completed as part of a structured Power BI & Power Automate training journey*  
*Dataset: Olist Brazilian E-Commerce — Kaggle*