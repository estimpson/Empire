SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dmaxAT_shipout] as
select	*
from	EEH.[dbo].[dmaxAT_shipout] with (READUNCOMMITTED)
GO
