SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_csm_sp_update_basepart_name]

as

declare @a table 
(
basepart varchar(7),
PartName varchar(500)
)

insert into @a
Select	left(part,7) BasePart,
		isNUll(max(name), 'No Desc')PartName
from		part
where	part in (select CoALESCE( part_number,part_original)
				from		shipper_detail
				full join	order_detail on shipper_detail.order_no = order_detail.order_no and shipper_detail.part_original=order_detail.part_number
				where	CoALESCE(due_date,date_shipped) > dateadd(mm,-3,getdate()))
group by left(part,7)

update bpa
set empire_application = a.PartName
from eeiuser.acctg_csm_base_part_attributes bpa join (select * from @a) a on bpa.base_part = a.basepart
where bpa.base_part = a.BasePart 
and bpa.base_part in (select basepart from @a)


GO
