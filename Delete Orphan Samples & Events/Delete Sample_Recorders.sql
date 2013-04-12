use nbndata
go

begin tran

delete from
	[sample_recorder]
output deleted.*
where sample_key in (
	select
		sr.sample_key as SAMPLE_RECORDER_KEY
	from
		[sample] as sa
	left outer join
		taxon_occurrence as txo on
		sa.sample_key = txo.sample_key
	inner join
		sample_recorder as sr on
		sa.sample_key = sr.sample_key
	where
		txo.sample_key is null
);

delete from
	[sample_sources]
output deleted.*
where sample_key in (
	select
		ss.sample_key
	from
		[sample] as sa
	left outer join
		taxon_occurrence as txo on
		sa.sample_key = txo.sample_key
	inner join
		sample_sources as ss on
		sa.sample_key = ss.sample_key
	where
		txo.sample_key is null
);

delete from
	[biotope_occurrence]
output deleted.*
where sample_key in (
	select
		bo.sample_key
	from
		[sample] as sa
	left outer join
		taxon_occurrence as txo on
		sa.sample_key = txo.sample_key
	inner join
		biotope_occurrence as bo on
		sa.sample_key = bo.sample_key
	where
		txo.sample_key is null
);

delete from
	[sample]
output deleted.*
where sample_key in (
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