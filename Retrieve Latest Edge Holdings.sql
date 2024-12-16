SELECT DISTINCT [Ticker]
FROM [InvestmentDB].[dbo].[MorningstarYchartsData]
WHERE [Attribute] = (SELECT MAX([Attribute]) FROM [InvestmentDB].[dbo].[MorningstarYchartsData])
  AND [Ticker] IS NOT NULL
