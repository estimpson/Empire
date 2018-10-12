SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[currency_conversion] as
select	*
from	EEH.[dbo].[currency_conversion] with (READUNCOMMITTED)
GO
