SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[EEHShipAccum] as
select	*
from	EEH.[FT].[EEHShipAccum] with (READUNCOMMITTED)
GO
