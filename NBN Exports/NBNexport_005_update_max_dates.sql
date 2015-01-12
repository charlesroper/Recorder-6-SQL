/* 
  Select the latest date from the TAXON_OCCURRENCE, TAXON_DETERMINATION, SAMPLE and
  SURVEY_EVENT tables. The latest data will be stuffed into the MAX_DATES table
  along with the TAXON_OCCURRENCE_KEY. This date can be used to compare whether a
  record has changed since last upload.
*/

set ansi_warnings off;  
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
	and txd.PREFERRED = 1
inner join
	SURVEY_EVENT se on
	sa.SURVEY_EVENT_KEY = se.SURVEY_EVENT_KEY

USE [NBNReporting]
GO
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MAX_DATES]') AND name = N'PK_TXO')
DROP INDEX [PK_TXO] ON [dbo].[MAX_DATES] WITH ( ONLINE = OFF )
GO

CREATE UNIQUE NONCLUSTERED INDEX [PK_TXO] ON [dbo].[MAX_DATES] 
(
	[TAXON_OCCURRENCE_KEY] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO