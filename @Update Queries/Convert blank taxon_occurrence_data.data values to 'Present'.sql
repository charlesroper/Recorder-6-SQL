use NBNData

begin tran

update TAXON_OCCURRENCE_DATA
set DATA = 'Present'
output
  inserted.TAXON_OCCURRENCE_KEY
  ,inserted.DATA
  ,inserted.ACCURACY
from
  TAXON_OCCURRENCE_DATA
where
  dbo.ufn_TrimWhiteSpaces(DATA) = ''

rollback tran

--SELECT 'Data Blank', 'Taxon_Occurrence' , Taxon_Occurrence_Key, DATA, ACCURACY
--FROM Taxon_Occurrence_data  
--WHERE ltrim(rtrim(data)) = ''