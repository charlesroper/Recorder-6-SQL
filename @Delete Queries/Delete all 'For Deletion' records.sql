use NBNData
go

begin tran

  print ''
  print 'Preparing data'

  declare @del varchar(12);  
  set @del = 'SXBRC_DELETE'
  
  declare @for_deletion_key VARCHAR(16);
  set @for_deletion_key = 'THU000020017494D' 
  
  -- Update TAXON_DETERMINATION
  update  TAXON_DETERMINATION
  set     ENTERED_BY = @del
  from    TAXON_DETERMINATION txd
  where   txd.TAXON_LIST_ITEM_KEY = @for_deletion_key
  
  -- Update TAXON_OCCURRENCE_DATA
  update  TAXON_OCCURRENCE_DATA
  set     ENTERED_BY = @del
  from    TAXON_OCCURRENCE_DATA txod
  join    TAXON_DETERMINATION txd on
          txod.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
  where   txd.TAXON_LIST_ITEM_KEY = @for_deletion_key  
  
  -- Update TAXON_OCCURRENCE
  update  TAXON_OCCURRENCE
  set     ENTERED_BY = @del
  from    TAXON_OCCURRENCE txo
  join    TAXON_DETERMINATION txd on
          txo.TAXON_OCCURRENCE_KEY = txd.TAXON_OCCURRENCE_KEY
  where   txd.TAXON_LIST_ITEM_KEY = @for_deletion_key
  
  print ''
  print 'Deleting data'
  delete from TAXON_DETERMINATION where ENTERED_BY = @del
  delete from TAXON_OCCURRENCE_DATA where ENTERED_BY = @del
  delete from TAXON_OCCURRENCE where ENTERED_BY = @del

rollback tran