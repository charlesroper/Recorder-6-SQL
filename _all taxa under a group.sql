select
	itn1.taxon_list_item_key
	,itn1.preferred_name
	,itn1.common_name
	,itg.taxon_list_item_key
	,itg.contained_list_item_key
from
	index_taxon_name itn1
inner join
	index_taxon_group itg on
	itn1.taxon_list_item_key = itg.taxon_list_item_key
where
	itn1.actual_name = 'chiroptera'


select distinct
	itn1.taxon_list_item_key
	,itn2.taxon_list_item_key
	,itn3.taxon_list_item_key
	,itn4.taxon_list_item_key
	,itg.taxon_list_item_key
	,itn1.common_name
	,itn1.preferred_name
	,itn4.preferred_name
	,itn4.common_name
from
	index_taxon_name itn1
inner join
	index_taxon_name itn2 on
	itn1.recommended_taxon_list_item_key = itn2.taxon_list_item_key
inner join
	index_taxon_name itn3 on
	itn2.taxon_list_item_key = itn3.recommended_taxon_list_item_key
inner join
	index_taxon_group itg on
	itn3.taxon_list_item_key = itg.taxon_list_item_key
inner join
	index_taxon_name itn4 on
	itg.contained_list_item_key = itn4.taxon_list_item_key
where
	itn1.actual_name = 'chiroptera'

-- All taxon_list_item_keys for 'chiroptera'
select distinct
	itn3.taxon_list_item_key
	,itn3.preferred_name
	,itn3.common_name
from 
	index_taxon_name itn1
inner join
	index_taxon_name itn2 on
	itn1.recommended_taxon_list_item_key = itn2.taxon_list_item_key
inner join
	index_taxon_name itn3 on
	itn2.taxon_list_item_key = itn3.recommended_taxon_list_item_key
where
	itn1.actual_name = 'chiroptera'

-- All taxon_list_item_keys for 'chiroptera' and below
select distinct
	itn3.taxon_list_item_key
	,itn3.preferred_name
	,itn3.common_name
	,itg.contained_list_item_key
	,itn4.preferred_name
	,itn4.common_name
	,itn4.taxon_list_item_key
from 
	index_taxon_name itn1
inner join
	index_taxon_name itn2 on
	itn1.recommended_taxon_list_item_key = itn2.taxon_list_item_key
inner join
	index_taxon_name itn3 on
	itn2.taxon_list_item_key = itn3.recommended_taxon_list_item_key
inner join
	index_taxon_group itg on
	itn3.taxon_list_item_key = itg.taxon_list_item_key
inner join
	index_taxon_name itn4 on
	itg.contained_list_item_key = itn4.taxon_list_item_key
inner join
	index_taxon_name itn5 on
	itn4.recommended_taxon_list_item_key = itn5.taxon_list_item_key
where
	itn1.actual_name = 'chiroptera'
order by
	itn4.preferred_name

-- recommended chiroptera
select top 1
	itn1.recommended_taxon_list_item_key
from
	index_taxon_name itn1
where
	itn1.preferred_name = 'chiroptera'

select distinct
	itn1.recommended_taxon_list_item_key
	,itn1.preferred_name
	,itn2.taxon_list_item_key
	,itn2.common_name
	,itn2.preferred_name
	,itn2.sort_order
from
	index_taxon_group itg
inner join
	index_taxon_name itn1 on
	itg.contained_list_item_key = itn1.taxon_list_item_key
inner join
	index_taxon_name itn2 on
	itn1.taxon_list_item_key = itn2.recommended_taxon_list_item_key
where
	itg.taxon_list_item_key = ( select top 1 itn1.recommended_taxon_list_item_key
								from index_taxon_name itn1
								where itn1.preferred_name = 'chiroptera' )
order by
	itn2.sort_order
	
