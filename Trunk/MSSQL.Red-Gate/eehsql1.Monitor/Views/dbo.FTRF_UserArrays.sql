SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_UserArrays] as
select	*
from	EEH.[dbo].[FTRF_UserArrays] with (READUNCOMMITTED)
GO
