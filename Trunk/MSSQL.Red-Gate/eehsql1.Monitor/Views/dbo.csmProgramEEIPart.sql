SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[csmProgramEEIPart] as
select	*
from	EEH.[dbo].[csmProgramEEIPart] with (READUNCOMMITTED)
GO
