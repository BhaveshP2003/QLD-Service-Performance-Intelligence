
# Data Dictionary
## Queensland Government Service Performance Intelligence

**Source:** Queensland Government Customer Service
Centre Wait Times dataset

**Dataset period:** 15 July 2018 – 10 June 2025

**Total records:** 146,219

**Grain:** One record per service centre per date
(based on initial duplicate-key validation).

## Column Definitions

| Column | Data Type | Description | Origin |
|---|---|---|---|
| Date | Date | Date of service centre observation | Source |
| CSC_NAME | Text | Name of customer service centre | Source |
| CUSTOMERS | Integer | Reported customer count | Converted from NUMBER_OF_CUSTOMERS |
| AVG_WAIT_TIME | Text | Original recorded waiting duration in HH:MM:SS format | Source |
| WAIT_MINUTES | Decimal | Average waiting duration converted to minutes | Derived |
| ZERO_WAIT_FLAG | Boolean | True when WAIT_MINUTES = 0 | Derived |
| LONG_WAIT_FLAG | Boolean | True when WAIT_MINUTES > 120 | Derived |
| CENTRE_CATEGORY | Text | All zero, Mixed or No zeros | Derived |

## Data Quality Findings

- Missing values: 0
- Fully duplicated records: 0
- Repeated centre-date combinations: 0
- Zero-wait records: 77,277
- Records with waits exceeding 120 minutes: 30
- Centres reporting only zero waiting times: 39

## Data Quality Rules

1. Preserve original source data.
2. Convert dates and customer counts to appropriate types.
3. Convert waiting durations into numeric minutes.
4. Flag zero-minute waiting times for review.
5. Flag waits above 120 minutes for investigation.
6. Do not remove unusual records without justification.
7. Retain source-to-processed data traceability.

## Known Limitations

- The meaning of zero waiting times is unverified.
- The 120-minute threshold is an analytical screening
  rule, not an official service standard.
- Centre coverage may not represent every Queensland
  customer service centre.
- Customer counts and average waiting times require
  source-definition validation before an overall
  weighted waiting-time KPI is interpreted.