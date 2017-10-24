SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vw_eei_CurrentBasePart]
as
Select	left(part,7) BasePart,
		isNUll(max(name), 'No Desc')PartName
from		part
where	part in (select CoALESCE( part_number,part_original)
				from		shipper_detail
				full join	order_detail on shipper_detail.order_no = order_detail.order_no and shipper_detail.part_original=order_detail.part_number
				where	CoALESCE(due_date,date_shipped) > dateadd(mm,-3,getdate()))
group by left(part,7)

GO
