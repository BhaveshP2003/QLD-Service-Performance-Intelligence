
-- BQ4: Which months have higher customer demand?
-- Monthly customer volume analysis

SELECT
    d.Year,
    d.Month,

    printf('%04d-%02d', d.Year, d.Month)
        AS YearMonth,

    SUM(f.Customers) AS TotalCustomerVisits,

    COUNT(*) AS RecordedCentreDays,

    COUNT(DISTINCT d.DateKey) AS RecordedDates,

    COUNT(DISTINCT f.CentreKey) AS ReportingCentres,

    ROUND(
        1.0 * SUM(f.Customers)
        / NULLIF(COUNT(*), 0),
        2
    ) AS AvgVisitsPerCentreDay

FROM FactServicePerformance AS f

INNER JOIN DimDate AS d
    ON f.DateKey = d.DateKey

GROUP BY
    d.Year,
    d.Month

ORDER BY
    d.Year,
    d.Month;
