USE NBNREPORTING
GO

SELECT 
  OCCURRENCE_KEY,
  SAMPLE_KEY,
  CASE WHEN [TAXON COMMON NAME] = [Recommended Taxon Name] THEN
    'A ' + [TAXON GROUP]
  ELSE
    [TAXON COMMON NAME]
  END AS [COMMON NAME],
  [Recommended Taxon Name],
  [TAXON GROUP],
  REPLACE([SAMPLE_SPATIAL_REF], ' ', '') AS GRID_REF,
  CASE WHEN [SAMPLE LOCATION NAME] IS NOT NULL THEN
    CASE WHEN [SAMPLE LOCATION NAME] != [SAMPLE LOCATION] THEN
      [SAMPLE LOCATION NAME] + ', ' + [SAMPLE LOCATION]
    ELSE
      [SAMPLE LOCATION]
    END
  ELSE
    [SAMPLE LOCATION]
  END AS LOCATION,
  [SAMPLE RECORDERS],
  SAMPLE_VAGUE_DATE_START,
  SAMPLE_VAGUE_DATE_END,
  NBNData.dbo.LCReturnVagueDateShort(SAMPLE_VAGUE_DATE_START, Sample_Vague_Date_End, Sample_Vague_Date_Type) AS DATE,
  NBNData.dbo.FormatDatePart(SAMPLE_VAGUE_DATE_START, SAMPLE_VAGUE_DATE_END, SAMPLE_VAGUE_DATE_TYPE, 0) AS [YEAR]
FROM
  WEALDEN_ALL