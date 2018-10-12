SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_GlobalArrays] as
select	*
from	EEH.[dbo].[FTRF_GlobalArrays] with (READUNCOMMITTED)
GO
