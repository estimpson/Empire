SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[BlanketOrderAlternates]
as
select
	OrderType = case when count(distinct ohAlternate2.order_no) = 1 then 'A' else coalesce(ohAlternate.status, 'O') end
,	ActiveOrderNo = ohActive.order_no
,	ActivePart = ohActive.blanket_part
,	AlternateOrderNo = ohAlternate.order_no
,	AlternatePart = ohAlternate.blanket_part
from
	dbo.order_header ohActive
	join dbo.edi_setups es
		on es.destination = ohActive.destination
	join dbo.order_header ohAlternate
		on ohAlternate.customer_part = ohActive.customer_part
		and ohAlternate.destination = ohActive.destination
		and
		(	coalesce(es.check_po, 'N') != 'Y' or
			ohAlternate.customer_po = ohActive.customer_po
		)
		and
		(	coalesce(es.check_model_year, 'N') != 'Y' or
			coalesce(ohAlternate.model_year, '') = coalesce(ohActive.model_year, '')
		)
	join dbo.order_header ohAlternate2
		on ohAlternate2.customer_part = ohActive.customer_part
		and ohAlternate2.destination = ohActive.destination
		and
		(	coalesce(es.check_po, 'N') != 'Y' or
			ohAlternate2.customer_po = ohActive.customer_po
		)
		and
		(	coalesce(es.check_model_year, 'N') != 'Y' or
			coalesce(ohAlternate2.model_year, '') = coalesce(ohActive.model_year, '')
		)
where
	ohActive.status = 'A'
	--and ohActive.blanket_part like 'NAL%'
	and ohActive.destination != 'EMPIREALABAMA'
	and ohActive.blanket_part not like '%-PT%'
	and ohAlternate.destination != 'EMPIREALABAMA'
	and ohAlternate.blanket_part not like '%-PT%'
	and ohAlternate2.destination != 'EMPIREALABAMA'
	and ohAlternate2.blanket_part not like '%-PT%'
group by
	coalesce(ohAlternate.status, 'O')
,	ohActive.order_no
,	ohActive.blanket_part
,	ohAlternate.order_no
,	ohAlternate.blanket_part
GO
