use nbndata
go

select
	sa.sample_key,
	se.spatial_ref,
	sa.spatial_ref
from 
	sample sa	
inner join 
	survey_event se on
	sa.survey_event_key = se.survey_event_key
where
	sa.entered_by != se.entered_by
and sa.custodian = 'THU00002'
order by
	sa.entry_date desc