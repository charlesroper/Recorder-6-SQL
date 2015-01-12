USE NBNReporting;

SELECT 
   Batch
  ,[4] AS '10 km'
  ,[5] AS 'Tetrad'
  ,[6] AS '1 km'
  ,[8] AS '100 m'
  ,[10] AS '10 m'
  ,[12] AS '1 m'
FROM
(SELECT
   LEN(GridReference) AS GridLen
  ,CASE 
      WHEN UpdatedOn >= '1900-01-01 00:00:00' AND UpdatedOn <= '2014-03-13 23:59:59' THEN '1900-01-01 - 2014-03-13' 
      WHEN UpdatedOn >= '2014-03-14 00:00:00' AND UpdatedOn <= '2014-10-10 23:59:59' THEN '2014-03-14 - 2014-10-10' 
      ELSE 'Other'
   END AS Batch
FROM
  ALL_NBN_clipped
) AS t
PIVOT
(
  COUNT(GridLen)
  FOR GridLen IN ([4], [5], [6], [8], [10], [12])
) AS pvt
ORDER BY
  pvt.Batch;