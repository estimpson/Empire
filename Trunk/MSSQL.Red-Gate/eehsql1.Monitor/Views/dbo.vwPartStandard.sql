SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwPartStandard] as
select	*
from	EEH.[dbo].[vwPartStandard] with (READUNCOMMITTED)
GO
