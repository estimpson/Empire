SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPPrA] as
select	*
from	EEH.[FT].[vwPPrA] with (READUNCOMMITTED)
GO
