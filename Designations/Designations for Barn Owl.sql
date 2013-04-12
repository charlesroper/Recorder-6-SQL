select * from taxon_designation_type
where taxon_designation_type_key in (
	select taxon_designation_type_key from index_taxon_designation
	where taxon_list_item_key = 'NHMSYS0020526231'
)
