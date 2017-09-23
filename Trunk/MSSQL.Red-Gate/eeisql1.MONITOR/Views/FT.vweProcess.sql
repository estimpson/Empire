SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweProcess]
(	Part,
	Description )
as
select	Part,
	Description
from	FT.vweHoldInventory
union all
select	Part,
	Description
from	FT.vweStandardPack
union all
select	Part,
	Description
from	FT.vweLeadDemand
union all
select	Part,
	Description
from	FT.vweTotalDemand
union all
select	Part,
	Description
from	FT.vweMinOnHand
union all
select	Part,
	Description
from	FT.vweRoundDown
GO
