SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwPartCustomer]
(	PartCode,
	CustomerCode,
	CustomerPart,
	StandardPack,
	Unit,
	BlanketPrice )
as
select	part, customer, customer_part, customer_standard_pack, customer_unit, blanket_price
from	dbo.part_customer
GO
