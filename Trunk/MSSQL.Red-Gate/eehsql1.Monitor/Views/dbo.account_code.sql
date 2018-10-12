SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[account_code] as
select	*
from	EEH.[dbo].[account_code] with (READUNCOMMITTED)
GO
