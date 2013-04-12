USE NBNData;

DECLARE @record_number int;
SET @record_number = 4000000; -- EDIT THIS LINE

WITH taxon_occurrences AS (
  SELECT ROW_NUMBER() OVER (ORDER BY entry_date) AS RowNumber, taxon_occurrence_key, ENTRY_DATE
  FROM Taxon_Occurrence
)
SELECT *
FROM taxon_occurrences
WHERE RowNumber in (@record_number, @record_number-1, @record_number+1)
ORDER BY RowNumber