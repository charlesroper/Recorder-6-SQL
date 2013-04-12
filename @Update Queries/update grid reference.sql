use NBNData
go

begin tran
	update 
		SURVEY_EVENT
	set
		SPATIAL_REF = 'TQ128077'
	output
		inserted.SURVEY_EVENT_KEY,
		inserted.SPATIAL_REF
	from
		SURVEY_EVENT
	where 
		cast(ENTRY_DATE as DATE) = '2010-07-30'
		and custodian = 'MMEEE7Y6' 
		and SPATIAL_REF = 'TQ134067'
rollback tran