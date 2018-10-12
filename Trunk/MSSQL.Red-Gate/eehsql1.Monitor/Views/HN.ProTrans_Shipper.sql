SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[ProTrans_Shipper] as
select	*
from	EEH.[HN].[ProTrans_Shipper] with (READUNCOMMITTED)
GO
