-- Explore Data Points --
SELECT TOP (10000) [ID],
       [DataPointName],
       [DataPointDescription],
       [RootProvider],
       [LastUpdate],
       [FirstAsOfDate],
       [LastAsOfDate],
       [UpdateFrequency],
       [Notes],
       [Currency]
FROM [MarketData].[dbo].[MeederDataPoints]
WHERE [DataPointDescription] LIKE '%10%';


