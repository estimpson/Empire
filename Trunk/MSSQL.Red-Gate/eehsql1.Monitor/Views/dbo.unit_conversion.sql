SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[unit_conversion] as
select	*
from	EEH.[dbo].[unit_conversion] with (READUNCOMMITTED)
GO
