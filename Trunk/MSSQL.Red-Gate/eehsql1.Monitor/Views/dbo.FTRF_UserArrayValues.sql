SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_UserArrayValues] as
select	*
from	EEH.[dbo].[FTRF_UserArrayValues] with (READUNCOMMITTED)
GO
