
-- BQ4: Customer demand by day of the week
-- Period: 2019-2024 (complete calendar years)

SELECT
    d.DayOfWeek,

    COUNT(*) AS RecordedCentreDays,

    COUNT(DISTINCT d.DateKey) AS RecordedDates,

    COUNT(DISTINCT f.CentreKey) AS ReportingCentres,

    SUM(f.Customers) AS TotalCustomerVisits,

    ROUND(
        1.0 * SUM(f.Customers)
        / NULLIF(COUNT(*), 0),
        2
    ) AS AvgVisitsPerCentreDay

FROM FactServicePerformance AS f

INNER JOIN DimDate AS d
    ON f.DateKey = d.DateKey

WHERE d.Year BETWEEN 2019 AND 2024

GROUP BY d.DayOfWeek

ORDER BY
    CASE d.DayOfWeek
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;
