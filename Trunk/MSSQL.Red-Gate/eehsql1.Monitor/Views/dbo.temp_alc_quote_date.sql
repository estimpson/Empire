SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[temp_alc_quote_date] as
select	*
from	EEH.[dbo].[temp_alc_quote_date] with (READUNCOMMITTED)
GO
