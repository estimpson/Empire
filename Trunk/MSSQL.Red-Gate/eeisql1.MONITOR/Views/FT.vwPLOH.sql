SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[vwPLOH]
as
select	Part = object.part,
	Location = object.location,
	OnHand = sum (object.std_quantity)
from	object
where	object.status in ('A','H') and
	object.type is null
group by
	object.part,
	object.location
GO
