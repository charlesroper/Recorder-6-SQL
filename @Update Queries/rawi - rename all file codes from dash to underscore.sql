use NBNData

if object_ID('tempdb..#locations') is not null
	drop table tempdb..#locations

-- create basic locations table
create table 
	#locations (
		location_key CHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS PRIMARY KEY,
		parent_key   CHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS )

-- insert initial 'parent' location
insert into 
	#locations (location_key, parent_key) 
select
	 l.LOCATION_KEY
	,l.LOCATION_KEY  
from  
	LOCATION l
where  
--	l.LOCATION_KEY = 'THU00002000006OE' -- West Sussex
    l.LOCATION_KEY = 'THU00002000007AD' -- East Sussex

-- Populate with 'child' locations
while 1=1 begin
	insert into #locations
	  select 
		 l.LOCATION_KEY
		,tinc.parent_key
	  from
		location l
	  inner join
		#locations tinc on 
		l.PARENT_KEY = tinc.location_key
	  left join
		#locations texc on
		l.LOCATION_KEY = texc.location_key
	  where
		texc.location_key is null
	if @@ROWCOUNT = 0
	  break
end

begin tran
	declare
		 @date			datetime
	    ,@userid		char(16)

	set @date		= GETDATE()
	set @userid		= 'THU00002000001TP'
	
	update
		LOCATION
	set
		 FILE_CODE = replace(loc.FILE_CODE, '-', '_')
		,CHANGED_BY = @userid
		,CHANGED_DATE = @date
	output
		 inserted.FILE_CODE
		,inserted.CHANGED_BY 
		,inserted.CHANGED_DATE 
	from
		LOCATION loc
	inner join 
		#locations l on
		loc.LOCATION_KEY = l.location_key
	where
		l.location_key != l.parent_key
		and loc.FILE_CODE like '%-%'
rollback tran