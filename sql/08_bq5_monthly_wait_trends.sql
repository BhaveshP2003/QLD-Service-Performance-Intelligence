
-- BQ5: Are waiting times improving?
-- Monthly waiting-time trends for centres
-- classified as "No zeros", 2019–2024.

WITH MonthlyWait AS (

    SELECT
        d.Year,
        d.Month,

        printf('%04d-%02d', d.Year, d.Month)
            AS YearMonth,

        COUNT(*) AS RecordedCentreDays,

        COUNT(DISTINCT f.CentreKey)
            AS ReportingCentres,

        SUM(f.Customers) AS TotalVisits,

        1.0 * SUM(f.Customers * f.WaitMinutes)
        / NULLIF(SUM(f.Customers), 0)
            AS WeightedWaitMinutes

    FROM FactServicePerformance AS f

    INNER JOIN DimDate AS d
        ON f.DateKey = d.DateKey

    INNER JOIN DimCentre AS c
        ON f.CentreKey = c.CentreKey

    WHERE d.Year BETWEEN 2019 AND 2024
      AND c.ReportingCategory = 'No zeros'

    GROUP BY d.Year, d.Month
),

MonthlyComparison AS (

    SELECT
        *,

        LAG(WeightedWaitMinutes) OVER (
            ORDER BY Year, Month
        ) AS PreviousMonthWait

    FROM MonthlyWait
)

SELECT
    YearMonth,
    ReportingCentres,
    RecordedCentreDays,
    TotalVisits,

    ROUND(WeightedWaitMinutes, 2)
        AS WeightedWaitMinutes,

    ROUND(PreviousMonthWait, 2)
        AS PreviousMonthWait,

    ROUND(
        WeightedWaitMinutes - PreviousMonthWait,
        2
    ) AS ChangeMinutes,

    ROUND(
        100.0 *
        (WeightedWaitMinutes - PreviousMonthWait)
        / NULLIF(PreviousMonthWait, 0),
        2
    ) AS MoMChangePercentage

FROM MonthlyComparison

ORDER BY YearMonth;
