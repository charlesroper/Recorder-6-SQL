use nbndata
go

if object_ID('tempdb..#jncc_newdata') is not null
	drop table tempdb..#jncc_newdata

begin transaction
	declare
		@date					      datetime
		,@determiner			  char(16)
		,@new_determiner		char(16)
		,@new_det_role			char(16)
		,@new_det_type			char(16)
		,@taxon_list_item_key	char(16)
		,@comment				    varchar(max)
		,@current_user			char(16)

	set @date					= GETDATE()
	set @determiner				= 'THU00002000002UQ' -- Hetty Wakeford
	set @new_determiner			= 'THU00002000001TQ' -- Penny Green
	set @new_det_role			= (select top 1 DETERMINER_ROLE_KEY from TAXON_DETERMINATION where DETERMINER = @new_determiner and PREFERRED = 1)
	set @new_det_type			= 'NBNSYS0000000001' -- Invalid
	set @comment				= 'The reputation of the original recorder has been called into question and this record has therefore been invalidated.'  
	set @current_user			= 'THU00002000001TP' -- Charles Roper

	-- Create temp table to hold new determination keys
	create table #jncc_newdata (
		orig_txd_key				char(16) collate SQL_Latin1_General_CP1_CI_AS
		,taxon_determination_key	char(16) collate SQL_Latin1_General_CP1_CI_AS
	)
	
	-- Insert all preferred determination keys by a given determiner into temp table
	insert into 
		#jncc_newdata (orig_txd_key)
	select
		txd.TAXON_DETERMINATION_KEY
	from
		TAXON_DETERMINATION txd
	where
		txd.DETERMINER = @determiner and txd.PREFERRED = 1
	
	-- Populate temp table with new determination keys
	declare 
		@original_key	char(16)
		,@new_key		char(16)
	
	declare csr_new_txd_key cursor for
		select orig_txd_key from #jncc_newdata
		open csr_new_txd_key
		fetch next from csr_new_txd_key into @original_key
		while @@FETCH_STATUS = 0
		begin
			exec spNextKey 'TAXON_DETERMINATION', @new_key output
			update
				#jncc_newdata
			set
				taxon_determination_key = @new_key
			where
				orig_txd_key = @original_key
			fetch next from csr_new_txd_key into @original_key
		end
	close csr_new_txd_key
	deallocate csr_new_txd_key
		
	-- Insert new determinations into the TAXON_DETERMINATION table
	insert into TAXON_DETERMINATION (
		TAXON_DETERMINATION_KEY
		,TAXON_LIST_ITEM_KEY
		,TAXON_OCCURRENCE_KEY
		,VAGUE_DATE_START
		,VAGUE_DATE_END
		,VAGUE_DATE_TYPE
		,COMMENT
		,PREFERRED
		,DETERMINER
		,DETERMINATION_TYPE_KEY
		,DETERMINER_ROLE_KEY
		,ENTERED_BY
		,ENTRY_DATE
	)
	select 
		j.taxon_determination_key	-- TAXON_DETERMINATION_KEY
		,txd.TAXON_LIST_ITEM_KEY	-- TAXON_LIST_ITEM_KEY
		,txd.TAXON_OCCURRENCE_KEY	-- TAXON_OCCURRENCE_KEY
		,CAST(@date as int) + 1		-- VAGUE_DATE_START
		,CAST(@date as int) + 1		-- VAGUE_DATE_END
		,'D'						-- VAGUE_DATE_TYPE
		,@comment					-- COMMENT
		,1							-- PREFERRED
		,@new_determiner			-- DETERMINER
		,@new_det_type				-- DETERMINATION_TYPE_KEY (Invalid)
		,@new_det_role				-- DETERMINER_ROLE_KEY
		,@current_user				-- ENTERED_BY
		,@date						-- ENTRY_DATE
	from
		#jncc_newdata j
	inner join
		TAXON_DETERMINATION txd on
		j.orig_txd_key = txd.TAXON_DETERMINATION_KEY
		
	-- Update the VERIFIED flag in the taxon occurrence
	update
		txo
	set
		txo.VERIFIED = dt.Verified
	from
		TAXON_OCCURRENCE txo
	inner join
		TAXON_DETERMINATION txd on
		txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
	inner join
		DETERMINATION_TYPE dt on
		txd.DETERMINATION_TYPE_KEY = dt.DETERMINATION_TYPE_KEY
	inner join
		#jncc_newdata j on
		txd.TAXON_DETERMINATION_KEY = j.taxon_determination_key
		
	-- Remove the PREFERRED flag from the old determinations
	update
		txd
	set
		PREFERRED = 0
	from
		TAXON_DETERMINATION txd
	inner join
		#jncc_newdata j on
		txd.TAXON_DETERMINATION_KEY = j.orig_txd_key
		
	select
		txd.*
		,txo.VERIFIED
	from
		TAXON_DETERMINATION txd
	inner join
		#jncc_newdata j on
		j.taxon_determination_key = txd.TAXON_DETERMINATION_KEY
	inner join
		TAXON_OCCURRENCE txo on
		txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
		
	select
		txd.*
	from
		TAXON_DETERMINATION txd
	inner join
		#jncc_newdata j on
		txd.TAXON_DETERMINATION_KEY = j.orig_txd_key

rollback transaction