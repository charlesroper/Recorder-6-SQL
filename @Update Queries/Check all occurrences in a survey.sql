begin tran

	declare
		 @date			datetime
		,@userid		char(16)
		,@survey_key	char(16)

	set @date		= GETDATE()
	set @userid		= 'THU00002000001TP' -- Charles Roper
	set @survey_key = 'THU000020000008V'

	update
		txo
	set 
		 txo.CHECKED		= 1
		,txo.CHECKED_BY		= @userid
		,txo.CHECKED_DATE	= @date
	
	output
		inserted.CHECKED,
		inserted.CHECKED_BY,
		inserted.CHECKED_DATE
	from
		SURVEY_EVENT se
	inner join
		[SAMPLE] sa on
		se.SURVEY_EVENT_KEY = sa.SURVEY_EVENT_KEY
	inner join
		TAXON_OCCURRENCE txo on
		sa.SAMPLE_KEY = txo.SAMPLE_KEY

	where
		SURVEY_KEY = @survey_key
	
rollback tran