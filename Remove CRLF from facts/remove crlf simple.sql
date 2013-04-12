-- Remove the CR&LFs from taxon facts
-- Show the relevant results

USE NBNData
GO

UPDATE TAXON_FACT
SET DATA = RTRIM(SUBSTRING(DATA, 1, (LEN(CAST(DATA AS VARCHAR(8000)))-2)))
WHERE RIGHT(CAST(DATA AS VARCHAR(8000)), 2) = (CHAR(13)+CHAR(10));
GO