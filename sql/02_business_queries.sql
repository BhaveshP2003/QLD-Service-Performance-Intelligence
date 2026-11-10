
-- STEP 18: Customer service centre performance
-- Business question:
-- Which centres handle the most customer visits?

SELECT
    c.CentreName,
    c.ReportingCategory,

    COUNT(*) AS RecordedDays,

    SUM(f.Customers) AS TotalCustomerVisits,

    SUM(f.ZeroWaitFlag) AS ZeroWaitDays,

    ROUND(
        100.0 * SUM(f.ZeroWaitFlag) / COUNT(*),
        2
    ) AS ZeroWaitPercentage

FROM FactServicePerformance AS f

INNER JOIN DimCentre AS c
    ON f.CentreKey = c.CentreKey

GROUP BY
    c.CentreName,
    c.ReportingCategory

ORDER BY TotalCustomerVisits DESC

LIMIT 10;