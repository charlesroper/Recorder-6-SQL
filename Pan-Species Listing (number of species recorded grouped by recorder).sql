select top 100
  recorder
  ,COUNT(taxon_list_item_key) as SPECIES_COUNT
from (
  select 
    dbo.FormatIndividual(I.TITLE, I.INITIALS, I.FORENAME, I.SURNAME) AS RECORDER
    ,itn2.TAXON_LIST_ITEM_KEY
    --,COUNT(itn2.TAXON_LIST_ITEM_KEY) as RECORD_COUNT
  from
    INDEX_TAXON_NAME itn1
  join
    INDEX_TAXON_NAME itn2 on
    itn1.RECOMMENDED_TAXON_LIST_ITEM_KEY = itn2.TAXON_LIST_ITEM_KEY
  join
    TAXON_DETERMINATION txd on
    itn1.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY and
    txd.PREFERRED = 1
  join
    TAXON_OCCURRENCE txo on
    txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
  join
    SAMPLE sa on
    txo.SAMPLE_KEY = sa.SAMPLE_KEY
  join
    SURVEY_EVENT se on
    sa.SURVEY_EVENT_KEY = se.SURVEY_EVENT_KEY
  join
    SURVEY_EVENT_RECORDER ser on
    se.SURVEY_EVENT_KEY = ser.SURVEY_EVENT_KEY
  join
    INDIVIDUAL i on
    ser.NAME_KEY = i.NAME_KEY
  group by
    dbo.FormatIndividual(I.TITLE, I.INITIALS, I.FORENAME, I.SURNAME)
    ,itn2.TAXON_LIST_ITEM_KEY
  ) as SUB
group by
  SUB.RECORDER
order by
  SPECIES_COUNT DESC
