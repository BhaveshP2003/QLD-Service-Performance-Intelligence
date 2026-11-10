
-- BQ1: How many customer visits are recorded?
-- Overall business performance KPI

SELECT
    COUNT(*) AS TotalRecords,

    COUNT(DISTINCT CentreKey) AS TotalCentres,

    COUNT(DISTINCT DateKey) AS RecordedDates,

    SUM(Customers) AS TotalCustomerVisits

FROM FactServicePerformance;
