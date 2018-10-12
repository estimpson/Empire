SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CustomerReleasePlans] as
select	*
from	EEH.[dbo].[CustomerReleasePlans] with (READUNCOMMITTED)
GO
