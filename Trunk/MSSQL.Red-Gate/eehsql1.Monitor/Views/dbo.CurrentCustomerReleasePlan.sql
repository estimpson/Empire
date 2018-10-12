SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CurrentCustomerReleasePlan] as
select	*
from	EEH.[dbo].[CurrentCustomerReleasePlan] with (READUNCOMMITTED)
GO
