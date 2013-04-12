SELECT DISTINCT
      ITN.TAXON_LIST_ITEM_KEY,
      ITNS1.COMMON_NAME         AS DESIGNATED_AS,
      TXG.TAXON_GROUP_NAME      AS TAXON_GROUP,
      TDT.KIND                  AS [STATUS_KIND],
      TDT.SHORT_NAME,
      TDT.LONG_NAME,
      TD.STATUS_GEOGRAPHIC_AREA,
      CONVERT(VARCHAR(10), TD.DATE_FROM, 103) AS DESIGNATED_ON, CONVERT(VARCHAR(10),
      TD.DATE_TO, 103)          AS DESIGNATION_EXPIRES

FROM  INDEX_TAXON_NAME AS ITN
INNER JOIN
      INDEX_TAXON_GROUP AS ITG ON
      ITN.TAXON_LIST_ITEM_KEY = ITG.CONTAINED_LIST_ITEM_KEY
INNER JOIN
      INDEX_TAXON_NAME AS ITNS1 ON
      ITG.TAXON_LIST_ITEM_KEY = ITNS1.TAXON_LIST_ITEM_KEY
INNER JOIN
      INDEX_TAXON_NAME AS ITNS2 ON
      ITNS1.RECOMMENDED_TAXON_LIST_ITEM_KEY = ITNS2.RECOMMENDED_TAXON_LIST_ITEM_KEY
INNER JOIN
      INDEX_TAXON_NAME AS ITNS3 ON
      ITNS2.TAXON_LIST_ITEM_KEY = ITNS3.RECOMMENDED_TAXON_LIST_ITEM_KEY
INNER JOIN
      TAXON_DESIGNATION AS TD ON
      ITNS2.TAXON_LIST_ITEM_KEY = TD.TAXON_LIST_ITEM_KEY
INNER JOIN
      TAXON_DESIGNATION_TYPE AS TDT ON
      TD.TAXON_DESIGNATION_TYPE_KEY = TDT.TAXON_DESIGNATION_TYPE_KEY
INNER JOIN
      TAXON_LIST_ITEM AS TLI ON
      ITN.TAXON_LIST_ITEM_KEY = TLI.TAXON_LIST_ITEM_KEY
INNER JOIN
      TAXON_VERSION AS TXV ON
      TLI.TAXON_VERSION_KEY = TXV.TAXON_VERSION_KEY
INNER JOIN
      TAXON_GROUP AS TXG ON
      TXV.OUTPUT_GROUP_KEY = TXG.TAXON_GROUP_KEY
