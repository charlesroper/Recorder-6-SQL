use NBNData
go

select top 100
	[year] = year(txo.ENTRY_DATE)
	,[entered per year] = COUNT( txo.TAXON_OCCURRENCE_KEY )
from
	TAXON_OCCURRENCE txo
group by
	year(txo.ENTRY_DATE)