
-- BQ6: Data quality exception analysis
-- Summarise waiting-time reporting patterns by category

SELECT
    c.ReportingCategory AS CentreCategory,

    COUNT(DISTINCT c.CentreKey) AS TotalCentres,

    COUNT(*) AS TotalRecords,

    SUM(f.Customers) AS TotalCustomerVisits,

    SUM(f.ZeroWaitFlag) AS ZeroWaitRecords,

    ROUND(
        100.0 * SUM(f.ZeroWaitFlag)
        / NULLIF(COUNT(*), 0),
        2
    ) AS ZeroWaitPercentage,

    SUM(f.LongWaitFlag) AS LongWaitRecords

FROM FactServicePerformance AS f

INNER JOIN DimCentre AS c
    ON f.CentreKey = c.CentreKey

GROUP BY c.ReportingCategory

ORDER BY
    CASE c.ReportingCategory
        WHEN 'All zero' THEN 1
        WHEN 'Mixed' THEN 2
        WHEN 'No zeros' THEN 3
    END;
