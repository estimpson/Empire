SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOHeaderEDI] as
select	*
from	EEH.[FT].[vwPOHeaderEDI] with (READUNCOMMITTED)
GO
