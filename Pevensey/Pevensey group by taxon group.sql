use nbnreporting
select
  w.[taxon group],
  --txg.sort_order,
  count(w.[taxon group]) as count
from
  wealden_all w
inner join
  NBNData.dbo.taxon_group txg on
  txg.taxon_group_name COLLATE Latin1_General_CI_AI = w.[taxon group]
where w.[taxon group] is not null
group by
  w.[taxon group], txg.sort_order
order by
  sort_order