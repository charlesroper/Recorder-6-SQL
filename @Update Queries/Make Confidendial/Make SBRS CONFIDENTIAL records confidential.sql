use nbndata
go

begin transaction
	update taxon_occurrence
	set taxon_occurrence.confidential = 1
	output INSERTED.*
	where comment like 'CONFIDENTIAL.%'
rollback transaction