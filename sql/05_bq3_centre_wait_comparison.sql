
-- BQ3: Which service centres experience higher waits?
-- Initial comparison: Centres with no zero-wait records

SELECT
    c.CentreName,
    c.ReportingCategory,

    COUNT(*) AS RecordedDays,

    SUM(f.Customers) AS TotalCustomerVisits,

    ROUND(
        SUM(f.Customers * f.WaitMinutes)
        / NULLIF(SUM(f.Customers), 0),
        2
    ) AS WeightedWaitMinutes,

    SUM(f.LongWaitFlag) AS LongWaitDays

FROM FactServicePerformance AS f

INNER JOIN DimCentre AS c
    ON f.CentreKey = c.CentreKey

WHERE c.ReportingCategory = 'No zeros'

GROUP BY
    c.CentreName,
    c.ReportingCategory

HAVING COUNT(*) >= 100

ORDER BY WeightedWaitMinutes DESC

LIMIT 10;
