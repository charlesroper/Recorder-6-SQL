use nbndata
go

select
	ln.item_name,
	min(l.spatial_ref) GridRef
from
	location_name ln
inner join
	location l on
	ln.location_key = l.location_key
group by
	item_name
order by
	item_name