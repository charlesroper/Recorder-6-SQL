use NBNData
go



begin tran

  declare @sk as varchar(16);
  declare @gr as varchar(16);
  set @sk = 'MMEEE2XHEEEG129F';
  set @gr = 'TQ30';

	update 
		SURVEY_EVENT
	set
		 SPATIAL_REF = @gr,
		 SPATIAL_REF_SYSTEM = 'OSGB'
	output
		inserted.SURVEY_EVENT_KEY,
		inserted.SPATIAL_REF,
		inserted.SPATIAL_REF_SYSTEM
	from
		SURVEY_EVENT se
	inner join
	  SAMPLE sa
	  on se.SURVEY_EVENT_KEY = sa.SURVEY_EVENT_KEY
	where 
    sa.SAMPLE_KEY = @sk
    
  update 
		SAMPLE
	set
		 SPATIAL_REF = @gr,
		 SPATIAL_REF_SYSTEM = 'OSGB'
	output
		inserted.SAMPLE_KEY,
		inserted.SPATIAL_REF,
		inserted.SPATIAL_REF_SYSTEM
	from
		SAMPLE sa
	where 
    sa.SAMPLE_KEY = @sk
rollback tran