SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOCurrentVsPlan] as
select	*
from	EEH.[FT].[vwPOCurrentVsPlan] with (READUNCOMMITTED)
GO
