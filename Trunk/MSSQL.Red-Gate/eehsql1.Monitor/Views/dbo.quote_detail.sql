SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[quote_detail] as
select	*
from	EEH.[dbo].[quote_detail] with (READUNCOMMITTED)
GO
