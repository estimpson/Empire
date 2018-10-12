SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ObjectLot] as
select	*
from	EEH.[FT].[ObjectLot] with (READUNCOMMITTED)
GO
