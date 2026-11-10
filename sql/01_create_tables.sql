
-- Dimension table: Dates
CREATE TABLE IF NOT EXISTS DimDate (
    DateKey INTEGER PRIMARY KEY,
    FullDate TEXT NOT NULL UNIQUE,
    Year INTEGER NOT NULL,
    Month INTEGER NOT NULL,
    DayOfWeek TEXT NOT NULL
);

-- Dimension table: Service Centres
CREATE TABLE IF NOT EXISTS DimCentre (
    CentreKey INTEGER PRIMARY KEY,
    CentreName TEXT NOT NULL UNIQUE,
    ReportingCategory TEXT NOT NULL
);

-- Fact table: Daily Service Performance
CREATE TABLE IF NOT EXISTS FactServicePerformance (
    PerformanceID INTEGER PRIMARY KEY,
    DateKey INTEGER NOT NULL,
    CentreKey INTEGER NOT NULL,
    Customers INTEGER NOT NULL,
    WaitMinutes REAL NOT NULL,
    ZeroWaitFlag INTEGER NOT NULL,
    LongWaitFlag INTEGER NOT NULL,

    FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey),

    FOREIGN KEY (CentreKey)
        REFERENCES DimCentre(CentreKey),

    UNIQUE (DateKey, CentreKey)
);
