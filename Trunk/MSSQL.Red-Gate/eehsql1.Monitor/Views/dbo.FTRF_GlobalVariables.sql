SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_GlobalVariables] as
select	*
from	EEH.[dbo].[FTRF_GlobalVariables] with (READUNCOMMITTED)
GO
