SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixiewire_quote_detail] as
select	*
from	EEH.[dbo].[dixiewire_quote_detail] with (READUNCOMMITTED)
GO
