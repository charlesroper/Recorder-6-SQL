select 
	TXO,
	SCI_NAME,
	COM_NAME,
	SORT_ORD,
	DATE,
	RECORDERS,
	SPATIAL_REF,
	SPATIAL_PRECISION,
	LOCATION,
	MIN(DESIGNATION) AS DESIGNATION,
	x,
	y
from
	temp_bap
where
	spatial_precision <= 4
group by
	TXO,
	SCI_NAME,
	COM_NAME,
	SORT_ORD,
	DATE,
	RECORDERS,
	SPATIAL_REF,
	SPATIAL_PRECISION,
	LOCATION,
	x,
	y
order by
	sort_ord
	