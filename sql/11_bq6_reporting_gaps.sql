
-- BQ6: Identify potential reporting gaps
-- Check weekdays between each centre's
-- first and last observation during 2019-2024.

WITH RECURSIVE Calendar(CalendarDate) AS (

    SELECT '2019-01-01'

    UNION ALL

    SELECT date(CalendarDate, '+1 day')
    FROM Calendar
    WHERE CalendarDate < '2024-12-31'
),

CentreBounds AS (

    SELECT
        f.CentreKey,
        c.CentreName,
        MIN(d.FullDate) AS FirstDate,
        MAX(d.FullDate) AS LastDate

    FROM FactServicePerformance f

    JOIN DimDate d
        ON f.DateKey = d.DateKey

    JOIN DimCentre c
        ON f.CentreKey = c.CentreKey

    WHERE d.Year BETWEEN 2019 AND 2024

    GROUP BY
        f.CentreKey,
        c.CentreName
),

ExpectedWeekdays AS (

    SELECT
        b.CentreKey,
        b.CentreName,
        cal.CalendarDate,

        CAST(
            strftime('%Y%m%d', cal.CalendarDate)
            AS INTEGER
        ) AS DateKey

    FROM CentreBounds b

    JOIN Calendar cal
        ON cal.CalendarDate
        BETWEEN b.FirstDate AND b.LastDate

    WHERE strftime('%w', cal.CalendarDate)
        IN ('1', '2', '3', '4', '5')
),

GapSummary AS (

    SELECT
        e.CentreName,

        COUNT(*) AS PotentialWeekdays,

        COUNT(f.PerformanceID)
            AS RecordedWeekdays,

        COUNT(*) - COUNT(f.PerformanceID)
            AS UnrecordedWeekdays

    FROM ExpectedWeekdays e

    LEFT JOIN FactServicePerformance f
        ON e.CentreKey = f.CentreKey
       AND e.DateKey = f.DateKey

    GROUP BY e.CentreName
)

SELECT
    CentreName,
    PotentialWeekdays,
    RecordedWeekdays,
    UnrecordedWeekdays,

    ROUND(
        100.0 * UnrecordedWeekdays
        / NULLIF(PotentialWeekdays, 0),
        2
    ) AS UnrecordedPercentage

FROM GapSummary

ORDER BY UnrecordedWeekdays DESC

LIMIT 10;
