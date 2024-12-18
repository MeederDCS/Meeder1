WITH LatestAttribute AS (
    -- For each unique PortfolioID, find the latest Attribute (based on the highest ID)
    SELECT 
        [PortfolioID],
        [Attribute],
        MAX([ID]) AS LatestID
    FROM [InvestmentDB].[dbo].[MorningstarYchartsData]
    GROUP BY [PortfolioID], [Attribute]
),
LatestTickers AS (
    -- Get all tickers associated with the latest Attribute for each PortfolioID
    SELECT 
        m.[PortfolioID],
        m.[Ticker]
    FROM 
        [InvestmentDB].[dbo].[MorningstarYchartsData] m
    JOIN 
        LatestAttribute la 
    ON m.[PortfolioID] = la.[PortfolioID]
    AND m.[Attribute] = la.[Attribute]
    AND m.[ID] = la.LatestID
    WHERE m.[Ticker] IS NOT NULL -- Remove NULL tickers
)
-- Get distinct tickers across all PortfolioIDs, ensuring no duplicates
SELECT DISTINCT
    [Ticker]
FROM 
    LatestTickers
WHERE 
    [Ticker] IS NOT NULL  -- Remove NULL tickers
    AND NOT ([Ticker] LIKE '%:DL' OR [Ticker] LIKE '$%')  -- Exclude tickers that end with ':DL' or start with '$'
ORDER BY 
    [Ticker];
