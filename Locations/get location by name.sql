-- Get the location name and key by name
-- By Charles Roper 08/02/2008

use nbndata
go

select
	ln.item_name,
	l.location_key,
	l.parent_key
from
	location l
inner join
	location_name ln on
	l.location_key = ln.location_key and
	ln.preferred = 'true'
where
	ln.item_name like 'brede cp'