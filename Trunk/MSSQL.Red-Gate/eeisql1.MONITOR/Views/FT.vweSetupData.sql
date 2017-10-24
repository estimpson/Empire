SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweSetupData]
(	Part,
	Description )
as
select	Part,
	Description
from	FT.vweBOM
union all
select	Part,
	Description
from	FT.vwePRt
union all
select	Part,
	Description
from	FT.vwePOH
union all
select	Part,
	Description
from	FT.vweSOD
union all
select	Part,
	Description
from	FT.vwePOD
union all
select	Part,
	Description
from	FT.vwePPrARM
union all
select	Part,
	Description
from	FT.vwePPrANOS
union all
select	Part,
	Description
from	FT.vwePPrADPOPM
union all
select	Part,
	Description
from	FT.vwePPrADPVSD
GO
