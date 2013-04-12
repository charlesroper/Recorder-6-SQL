use NBNData
go

begin tran
	-- Update ZERO_ABUNDANCE field in TAXON_OCCURRENCE
	update 
		txo
	set
		txo.ZERO_ABUNDANCE = 1
	output
		inserted.ZERO_ABUNDANCE,
		inserted.TAXON_OCCURRENCE_KEY
	from
		TAXON_OCCURRENCE_DATA txod
	inner join
		TAXON_OCCURRENCE txo
		on txod.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
	where
		txod.DATA like 'zero'
		
	-- Update DATA field in TAXON_OCCURRENCE_DATA
	update 
		txod
	set
		txod.DATA = 0
	output
		inserted.DATA,
		inserted.TAXON_OCCURRENCE_DATA_KEY
	from
		TAXON_OCCURRENCE_DATA txod
	where
		txod.DATA like 'zero'
commit tran