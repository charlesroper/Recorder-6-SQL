USE NBNReporting;

declare @first_date as smalldatetime;
declare @last_date as smalldatetime;

--  Note about dates: http://stackoverflow.com/a/22081848/1944

---------------------------------------------------------------

--  INITIAL EXPORT
--  All records on or before 13/03/2014 23:59:59

--set @first_date = '1900-01-01 00:00:00';
--set @last_date  = '2014-03-13 23:59:59';

---------------------------------------------------------------

--  17 OCTOBER 2014 UPDATE
--  Deadline date is: 17/10.2014
--  Export date is:   10/10/2014
--  All records between 14/03/2014 and 10/10/2014
set @first_date = '2014-03-14 00:00:00';
set @last_date  = '2014-10-10 23:59:59'; 

---------------------------------------------------------------

--  Use this if ALL records are needed, regardless of date.
--set @first_date = '1900-01-01';
--set @last_date = '2079-06-06';

SELECT
  [RecordKey]
  ,[UpdatedOn]
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
INTO
  ALL_NBN_140314_141010
FROM
  [NBNReporting].[dbo].[ALL_NBN_clipped] as anc
WHERE
    anc.UpdatedOn >= @first_date
and anc.UpdatedOn <= @last_date
-- WHERE
  -- Restrict to the appropriate date range for export.
  -- Use a range from the day after the previous
  -- export up to the end of the previous current day.
  
  -- E.g., if the previous date was 2014-03-13 and
  -- the current day is 2014-05-18 then the range
  -- should be 2014-03-14 to 2014-05-17
  -- [Updated] <= '2014-03-13'
GO