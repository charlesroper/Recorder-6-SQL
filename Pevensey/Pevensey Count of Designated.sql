/* Count Designated Query
   This query counts the number of records within NBNReporting.WEALDEN_ALL
   that have a designation.
*/

USE NBNREPORTING
GO

SELECT 
  OCCURRENCE_KEY
INTO
  #NBNREPORTING_TEMP
FROM
  WEALDEN_ALL
INNER JOIN
  NBNData.dbo.VW_DESIGNATIONS DES ON
  LIST_ITEM_KEY COLLATE Latin1_General_CI_AI = DES.TAXON_LIST_ITEM_KEY
GROUP BY
  OCCURRENCE_KEY
GO

SELECT COUNT(*) AS "Count of Designated" FROM #NBNREPORTING_TEMP
GO

DROP table #NBNREPORTING_TEMP
GO