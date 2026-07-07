# NHS A&E Waiting Times Analysis (2021–2025)

An end-to-end data analysis of Accident & Emergency (A&E) four-hour waiting time performance across England's major A&E departments, using official NHS England data from 2021 to 2025.

**Tools used:** Python (pandas), SQL logic, Power BI, Excel

---

## The Question

> **How have A&E four-hour waiting times varied across English regions since 2021, and which trusts consistently miss the four-hour target?**

The NHS operational standard is that **95% of A&E patients should be admitted, transferred, or discharged within four hours** of arrival. This project measures how far reality has drifted from that target, where the problem is worst, and how it has changed over time.

---

## Dashboard

![NHS A&E Dashboard](nhs_dashboard.png)

---

## Key Findings

**1. Performance collapsed after 2021 and never recovered.**
Average four-hour performance for major A&E departments fell from **86.6% (March 2021)** to **71.7% (March 2022)** — a drop of roughly 15 percentage points — and has stayed flat at around **71%** every year since. The unusually high 2021 figure reflects COVID-era conditions, when A&E attendances were suppressed by lockdown; performance crashed as normal demand returned in 2022 and has plateaued well below target ever since.

**2. No region meets the target — and the gap between regions is wide.**
Every one of England's seven regions sits far below the 95% standard. The **North West** consistently performs worst (~66–70%), while **London** performs best (~74%), a gap of roughly 8 percentage points that persists across the whole period.

**3. A small group of trusts are the worst performers.**
In March 2025, the lowest-performing major A&E trusts were:

| Trust | Region | % within 4 hours |
|---|---|---|
| The Shrewsbury and Telford Hospital NHS Trust | Midlands | 56.0% |
| Hull University Teaching Hospitals NHS Trust | North East & Yorkshire | 56.8% |
| East Cheshire NHS Trust | North West | 57.9% |
| University Hospitals Birmingham NHS Foundation Trust | Midlands | 58.6% |
| University Hospitals of Leicester NHS Trust | Midlands | 60.0% |

---

## Method

1. **Data collection** — Downloaded monthly A&E CSV files (March 2021–2025) from NHS England's official *A&E Attendances and Emergency Admissions* statistics.
2. **Cleaning (Python / pandas)** — Loaded each file, selected the relevant columns, and combined the three attendance types (Type 1 major A&E, Type 2, and Other) and their corresponding over-four-hour counts.
3. **Metric calculation** — The percentage within four hours is not provided in the raw data, so it was calculated directly:

   `% within 4 hours = (total attendances − attendances over 4 hours) ÷ total attendances × 100`

4. **Filtering** — Restricted the analysis to organisations with meaningful major A&E (Type 1) activity, so walk-in and urgent care centres do not distort the comparison. Removed NHS summary ("Total") rows that would otherwise be miscounted as a region.
5. **Reusable function** — Wrapped the cleaning logic in a function and applied it across all five yearly files, stacking them into one combined dataset of 623 trust-year records.
6. **Aggregation** — Grouped the data by year and by region to produce the national trend and regional comparison.
7. **Visualisation (Power BI)** — Built a three-part dashboard: a national trend line, a regional comparison bar chart, and a ranked table of worst-performing trusts.

---

## Files in this Repository

| File | Description |
|---|---|
| `nhs_ae_analysis.ipynb` | The Python notebook: data cleaning, metric calculation, and aggregation |
| `ae_clean_all_years.csv` | Cleaned trust-level data, all years combined |
| `ae_trend_by_year.csv` | National four-hour performance by year |
| `ae_regional_by_year.csv` | Regional performance breakdown by year |
| `nhs_dashboard.png` | The final Power BI dashboard |

---

## Notes and Limitations

- **March was chosen as a consistent comparison month** across all years, to avoid seasonal distortion (A&E performance varies significantly between winter and summer). Comparing the same month year-on-year isolates the underlying trend.
- The **2021 baseline is affected by the COVID-19 pandemic** and should be read as an atypical year rather than a "normal" benchmark.
- Performance is averaged across trusts within a region; this treats each trust equally rather than weighting by attendance volume. A volume-weighted view is a natural extension.

---

## What I'd Do Next

- **Weight regional averages by attendance volume**, so larger trusts influence the regional figure proportionally to the number of patients they see.
- **Add more months** to move from an annual snapshot to a full monthly time series, revealing seasonal (winter) pressure patterns.
- **Bring in the 12-hour wait data** already present in the source files, to analyse the most severe delays (patients waiting 12+ hours from decision-to-admit).
- **Join to population or deprivation data** by region to explore whether A&E performance correlates with wider socioeconomic factors.

---

## Data Source

NHS England — *A&E Attendances and Emergency Admissions* monthly statistics.
Publicly available at: https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/

*This analysis uses open public data and is intended as a portfolio demonstration of data cleaning, analysis, and visualisation.*
