SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_SQLReturnValues] as
select	*
from	EEH.[dbo].[FTRF_SQLReturnValues] with (READUNCOMMITTED)
GO