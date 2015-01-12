-- Find all records where there are 2 taxon occurrence keys in MAX_DATES

SELECT
    d.TAXON_OCCURRENCE_KEY, txd.ENTRY_DATE
FROM (
     SELECT 
         taxon_occurrence_key, MaxDate,
         ROW_NUMBER() OVER (PARTITION BY taxon_occurrence_key ORDER BY MaxDate) AS counter
     FROM MAX_DATES
) AS d
inner join
  NBNData.dbo.TAXON_DETERMINATION txd on
  d.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY

WHERE counter != 1
order by counter desc
