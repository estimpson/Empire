SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[PalletLot] as
select	*
from	EEH.[FT].[PalletLot] with (READUNCOMMITTED)
GO
