use nbndata
go

begin transaction

  declare
    @date                 datetime
    ,@userid              char(16)
    ,@taxon_list_item_key char(16)
    ,@comment             varchar(max)
    ,@original_comment    varchar(max)

  set @date = GETDATE()
  set @userid = 'THU00002000001TP' -- Charles Roper


  -- Wood White
  set @taxon_list_item_key  = 'NHMSYS0000550375'
  set @comment = '[CONFIDENTIAL: All Wood White records have been made confidential in the SxBRC database in line with Butterfly Conservation''s request to do so. October 2012.]'


  update
    txo
  set
    txo.confidential = 1
    ,txo.CHANGED_BY = @userid
    ,txo.CHANGED_DATE = @date
    ,txo.COMMENT = case
      when (txo.COMMENT is not null or cast(txo.COMMENT as varchar(max)) = '') then @comment + ' ' + dbo.ufn_RtfToPlaintext(dbo.ufn_TrimWhiteSpaces(cast(txo.COMMENT as varchar(max))))
      when txo.COMMENT is null then @comment
    end
  output
    inserted.CONFIDENTIAL
    ,inserted.CHANGED_BY
    ,inserted.CHANGED_DATE
    ,inserted.ENTRY_DATE as ORIGINAL_ENTRY_DATE
    ,inserted.COMMENT
  from
    INDEX_TAXON_NAME itn
  inner join
    INDEX_TAXON_NAME itn_x
    on itn.TAXON_LIST_ITEM_KEY = itn_x.RECOMMENDED_TAXON_LIST_ITEM_KEY
  inner join
    TAXON_DETERMINATION txd
    on itn_x.TAXON_LIST_ITEM_KEY = txd.TAXON_LIST_ITEM_KEY
  inner join
    TAXON_OCCURRENCE txo
    on txd.TAXON_OCCURRENCE_KEY = txo.TAXON_OCCURRENCE_KEY
  where
    itn.TAXON_LIST_ITEM_KEY = @taxon_list_item_key
    and txo.CONFIDENTIAL != 1

rollback transaction
