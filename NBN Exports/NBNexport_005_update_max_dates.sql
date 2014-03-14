use NBNData;

IF OBJECT_ID('NBNReporting.dbo.MAX_DATES', 'U') IS NOT NULL
  DROP TABLE NBNReporting.dbo.MAX_DATES;
  
select distinct
	txo.TAXON_OCCURRENCE_KEY
	,(SELECT Max(v) FROM (VALUES 
		(txo.ENTRY_DATE)
		,(txo.CHANGED_DATE)
		,(txd.ENTRY_DATE)
		,(txd.CHANGED_DATE)
		,(sa.ENTRY_DATE)
		,(sa.CHANGED_DATE)
		,(se.ENTRY_DATE)
		,(se.CHANGED_DATE)
		) AS value(v)
	) as [MaxDate]
into
  NBNReporting.dbo.MAX_DATES
from
	TAXON_OCCURRENCE txo
inner join
	SAMPLE sa on
	txo.SAMPLE_KEY = sa.SAMPLE_KEY
inner join 
	TAXON_DETERMINATION txd on
	txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
inner join
	SURVEY_EVENT se on
	sa.SURVEY_EVENT_KEY = se.SURVEY_EVENT_KEY
--where
--	txo.TAXON_OCCURRENCE_KEY = 'THU000020002PLKE'