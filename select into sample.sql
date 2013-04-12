USE NBNData
GO

IF object_ID('NBNReporting.dbo.samples') IS NOT NULL
	DROP TABLE NBNReporting.dbo.samples

SELECT
  ObjectID = IDENTITY(int,1,1),
  SAMPLE_KEY,
  LAT,
  LONG
INTO 
  NBNReporting.dbo.samples
FROM
  SAMPLE