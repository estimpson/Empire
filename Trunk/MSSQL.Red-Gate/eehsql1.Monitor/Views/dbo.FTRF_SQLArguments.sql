SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_SQLArguments] as
select	*
from	EEH.[dbo].[FTRF_SQLArguments] with (READUNCOMMITTED)
GO
