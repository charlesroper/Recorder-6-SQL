use NBNData
go

IF object_ID('NBNReporting.dbo.StatsForHenri') IS NOT NULL
	DROP TABLE NBNReporting.dbo.StatsForHenri

select distinct
  ROWID = IDENTITY(int,1,1)
	,SCI_NAME = itnr.PREFERRED_NAME
	,COM_NAME = case when itnr.PREFERRED_NAME = itnr.COMMON_NAME then
		txg.TAXON_GROUP_NAME
	else
		itnr.COMMON_NAME
	end
	,txg.TAXON_GROUP_NAME
  ,txg.SORT_ORDER
  ,X = dbo.LCReturnEastings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM)
	,Y = dbo.LCReturnNorthings_c(REPLACE(SA.SPATIAL_REF, ' ', ''), SA.SPATIAL_REF_SYSTEM)
into NBNReporting.dbo.StatsForHenri
from
	INDEX_TAXON_NAME itn
join
	INDEX_TAXON_NAME itnr ON
	itn.RECOMMENDED_TAXON_LIST_ITEM_KEY = itnr.TAXON_LIST_ITEM_KEY
join
  TAXON_DETERMINATION txd on
  itn.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY
join
  TAXON_OCCURRENCE txo on
  txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
join
  SAMPLE sa on
  txo.SAMPLE_KEY = sa.SAMPLE_KEY
join
  VW_TAXON_GROUP txg on
  txd.TAXON_LIST_ITEM_KEY = txg.TAXON_LIST_ITEM_KEY