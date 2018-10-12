SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[alc_quote_date] as
select	*
from	EEH.[dbo].[alc_quote_date] with (READUNCOMMITTED)
GO
