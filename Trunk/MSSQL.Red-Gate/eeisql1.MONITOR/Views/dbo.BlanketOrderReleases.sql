SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[BlanketOrderReleases]
as
select
	ActiveOrderNo = ohActive.order_no
,	ReleaseNo = od.release_no
,	ReleaseDT = od.due_date
,	ReleaseType = min(od.type)
,	QtyRelease = sum(od.std_qty)
from
	dbo.order_detail od
	join dbo.order_header oh
		join dbo.order_header ohActive
			join dbo.edi_setups es
				on es.destination = ohActive.destination
			on ohActive.customer_part = oh.customer_part
			and ohActive.destination = oh.destination
			and
			(	coalesce(es.check_po, 'N') != 'Y' or
				ohActive.customer_po = oh.customer_po
			)
			and
			(	coalesce(es.check_model_year, 'N') != 'Y' or
				coalesce(ohActive.model_year, '') = coalesce(oh.model_year, '')
			)
			and ohActive.status = 'A'
		on od.order_no = oh.order_no
group by
	ohActive.order_no
,	od.due_date
,	od.release_no
GO
