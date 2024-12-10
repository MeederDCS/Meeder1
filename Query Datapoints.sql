-- Query Datapoints
SELECT TOP (10000) [ID]
      ,[DataPointId]
      ,[AsOfDate]
      ,[DataPointValue]
      ,[ProviderId]
      ,[ValidationLevel]
  FROM [MarketData].[dbo].[MeederDataPointPITs]
WHERE [DataPointId] IN (1537);
