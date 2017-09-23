SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[eeisp_rpt_planning_noCSM_forecast]

as

Begin


Select	order_header.customer,
		customer.name,
		destination.name,
		left(part.part,7) as BasePart,
		part.part,
		part.name,
		order_detail.due_date,
		order_detail.quantity,
		order_detail.alternate_price,
		order_detail.quantity*order_detail.alternate_price,
		part_standard.price,
		prod_start,
		prod_end,
		(select sum(qty_packed)
		from		shipper_detail
		where	date_shipped >= dateadd(yy,-1,getdate()) and
				left(part_original,7) = left(part.part,7)) as PriorYearunits
from		part
join		part_standard on part.part = part_standard.part
join		part_eecustom on part.part = part_eecustom.part
left join	order_header on part.part = order_header.blanket_part
left join	order_detail on part.part = order_detail.part_number
left join	customer on order_header.customer = customer.customer
left join	destination on order_header.destination = destination.destination
where	left(part.part,7) in (
		
		

Select	left(part_number,7) BasePart
from		order_detail
join		part_eecustom on order_detail.part_number = part_eecustom.part
where	due_date>= getdate() and
		quantity > 10 and 
		left(part_number,7) not in (
select 	base_part
from		[EEIUser].[acctg_csm_vw_select_total_demand]
where	total_2009+total_2010>1)
group by left(part_number,7)
having	isNull(max(prod_end),getdate())>=getdate()
UNION

Select	left(part,7)
from		part_eecustom 
left join	order_detail on part_eecustom.part = order_detail.part_number
where	prod_start>= getdate() and
		left(part,7) not in (
select 	base_part
from		[EEIUser].[acctg_csm_vw_select_total_demand]
where	total_2009+total_2010>1)
group by left(part,7))

order by 4

end
GO
