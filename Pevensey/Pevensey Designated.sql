USE NBNREPORTING
GO

SELECT
  MIN(CASE WHEN [Taxon Common Name] = [Recommended Taxon Name] THEN
    'A ' + A.[Taxon Group]
  ELSE
    [Taxon Common Name]
  END) AS [COMMON NAME],
  [Recommended Taxon Name],
  A.[Taxon Group],
  MIN(SAMPLE_VAGUE_DATE_START) AS [FIRST RECORDED],
  MAX(SAMPLE_VAGUE_DATE_END) AS [LAST RECORDED],
  COUNT(OCCURRENCE_KEY) AS COUNT,
  [RECOMMENDED TAXON SORT ORDER],
  MIN(A.LIST_ITEM_KEY) AS [LIST ITEM KEY],
  DES.STATUS_KIND AS STATUS
INTO
  #NBNREPORTING_TEMP
FROM
  WEALDEN_ALL A
LEFT OUTER JOIN
  NBNData.dbo.VW_DESIGNATIONS DES ON
  A.LIST_ITEM_KEY COLLATE Latin1_General_CI_AI = DES.TAXON_LIST_ITEM_KEY
WHERE
  A.[Taxon Group] IS NOT NULL AND
  A.[SAMPLE_VAGUE_DATE_TYPE] != 'U'
GROUP BY 
  [Recommended Taxon Name], A.[Taxon Group], [RECOMMENDED TAXON SORT ORDER], DES.STATUS_KIND
ORDER BY
  [RECOMMENDED TAXON SORT ORDER]
GO

SELECT
  [LIST ITEM KEY],
  [COMMON NAME],
  [Recommended Taxon Name],
  [Taxon Group],
  NBNData.dbo.LCReturnDateShort([FIRST RECORDED],'D','F') AS [FIRST RECORDED],
  NBNData.dbo.LCReturnDateShort([LAST RECORDED], 'D', 'F') AS [LAST RECORDED],
  [COUNT],
  STATUS
FROM
  #NBNREPORTING_TEMP
WHERE
  STATUS IS NOT NULL
GO

DROP TABLE #NBNREPORTING_TEMP
GO
