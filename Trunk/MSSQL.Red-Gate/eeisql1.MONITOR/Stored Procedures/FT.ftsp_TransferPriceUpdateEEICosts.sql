SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [FT].[ftsp_TransferPriceUpdateEEICosts]
as
update	part_standard
set	material = isnull (nullif (material_cum, 0),
	(	select	max (blanket_price)
		from	part_customer
		where	part_standard.part = part_customer.part)),
	material_cum = isnull (nullif (material_cum, 0),
	(	select	max (blanket_price)
		from	part_customer
		where	part_standard.part = part_customer.part))
from	part_standard
	join part on part.part = part_standard.part
where	part.class = 'M' and
	part.type = 'F' and
	isnull (part_standard.material_cum, -1) <= 0 and
	exists
	(	select	*
		from	part_customer
		where	part_standard.part = part_customer.part)
GO
