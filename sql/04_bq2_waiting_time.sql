
-- BQ2: How long do customers wait?
-- Compare recorded weighted waiting times
-- while accounting for zero-wait reporting uncertainty.

SELECT
    COUNT(*) AS TotalRecords,

    SUM(Customers) AS TotalVisits,

    SUM(ZeroWaitFlag) AS ZeroWaitRecords,

    -- Weighted average including recorded zeros
    ROUND(
        SUM(Customers * WaitMinutes)
        / NULLIF(SUM(Customers), 0),
        2
    ) AS WeightedWait_AllRecords,

    -- Weighted average for positive-wait records only
    ROUND(
        SUM(
            CASE
                WHEN WaitMinutes > 0
                THEN Customers * WaitMinutes
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN WaitMinutes > 0
                    THEN Customers
                END
            ), 0
        ),
        2
    ) AS WeightedWait_PositiveOnly,

    -- Percentage of visits represented by zero-wait records
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN WaitMinutes = 0
                THEN Customers
                ELSE 0
            END
        ) / NULLIF(SUM(Customers), 0),
        2
    ) AS ZeroWait_VisitPercentage

FROM FactServicePerformance;
