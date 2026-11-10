
-- BQ5: Annual waiting-time trend analysis
-- Compare centres reporting in all six years

WITH ConsistentCentres AS (

    SELECT f.CentreKey

    FROM FactServicePerformance f

    JOIN DimDate d
        ON f.DateKey = d.DateKey

    JOIN DimCentre c
        ON f.CentreKey = c.CentreKey

    WHERE d.Year BETWEEN 2019 AND 2024
      AND c.ReportingCategory = 'No zeros'

    GROUP BY f.CentreKey

    HAVING COUNT(DISTINCT d.Year) = 6
),

AnnualWait AS (

    SELECT
        d.Year,

        COUNT(DISTINCT f.CentreKey)
            AS ReportingCentres,

        COUNT(*) AS RecordedCentreDays,

        SUM(f.Customers) AS TotalVisits,

        ROUND(
            1.0 * SUM(f.Customers * f.WaitMinutes)
            / NULLIF(SUM(f.Customers), 0),
            2
        ) AS WeightedWaitMinutes

    FROM FactServicePerformance f

    JOIN DimDate d
        ON f.DateKey = d.DateKey

    JOIN ConsistentCentres c
        ON f.CentreKey = c.CentreKey

    WHERE d.Year BETWEEN 2019 AND 2024

    GROUP BY d.Year
)

SELECT
    Year,
    ReportingCentres,
    RecordedCentreDays,
    TotalVisits,
    WeightedWaitMinutes,

    ROUND(
        WeightedWaitMinutes -
        LAG(WeightedWaitMinutes) OVER (
            ORDER BY Year
        ),
        2
    ) AS YearlyChangeMinutes

FROM AnnualWait

ORDER BY Year;
