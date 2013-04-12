use nbndata
go

begin tran

delete from
	[sample]
output 
	deleted.*
where
	sample_key in (
		select
			sa.sample_key
		from
			[sample] as sa
		left outer join
			taxon_occurrence as txo on
				sa.sample_key = txo.sample_key
		where
			txo.sample_key is null
	);

rollback tran