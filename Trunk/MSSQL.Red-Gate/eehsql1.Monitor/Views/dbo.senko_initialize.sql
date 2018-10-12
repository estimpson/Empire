SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[senko_initialize] as
select	*
from	EEH.[dbo].[senko_initialize] with (READUNCOMMITTED)
GO
