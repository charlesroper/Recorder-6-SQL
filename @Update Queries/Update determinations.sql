use nbndata
go

begin tran

update
  txd
set
  TAXON_LIST_ITEM_KEY = 'NHMSYS0000528722'
output
  inserted.TAXON_LIST_ITEM_KEY
from
  INDEX_TAXON_NAME itn
inner join
  TAXON_DETERMINATION txd
  on itn.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY
inner join
  TAXON_OCCURRENCE txo
  on txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
inner join
  SAMPLE sa
  on txo.SAMPLE_KEY = sa.SAMPLE_KEY
inner join
  SURVEY_EVENT ev
  on sa.SURVEY_EVENT_KEY = ev.SURVEY_EVENT_KEY
inner join
  SURVEY su
  on ev.SURVEY_KEY = su.SURVEY_KEY
where
  itn.PREFERRED_NAME = 'Hepialus lupulinus'
  and txo.SURVEYORS_REF like 'SOS%'
  
 rollback tran