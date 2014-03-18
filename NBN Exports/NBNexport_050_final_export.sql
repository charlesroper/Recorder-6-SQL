USE NBNReporting;

SELECT
  [RecordKey]
  --,[Updated]
  ,[TaxonVersionKey]
  ,[SurveyKey]
  ,[SampleKey]
  ,[StartDate]
  ,[EndDate]
  ,[DateType]
  ,[GridReference]
  ,[Projection]
  ,[Precision]
  --,[X]
  --,[Y]
  ,[Sensitive]
  ,[ZeroAbundance]
  ,[SiteKey]
  ,[SiteName]
  ,[SampleMethod]
  ,[Recorder]
  ,[Determiner]
  ,[Abundance]
  ,[Comment]
FROM
  [NBNReporting].[dbo].[ALL_NBN_clipped]
WHERE
  -- Restrict to the appropriate date range for export.
  -- Use a range from the day after the previous
  -- export up to the end of the previous current day.
  
  -- E.g., if the previous date was 2014-03-13 and
  -- the current day is 2014-05-18 then the range
  -- should be 2014-03-14 to 2014-05-17
  [Updated] <= '2014-03-13'
GO


