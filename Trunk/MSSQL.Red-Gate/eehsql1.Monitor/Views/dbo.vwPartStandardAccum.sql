SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwPartStandardAccum] as
select	*
from	EEH.[dbo].[vwPartStandardAccum] with (READUNCOMMITTED)
GO
