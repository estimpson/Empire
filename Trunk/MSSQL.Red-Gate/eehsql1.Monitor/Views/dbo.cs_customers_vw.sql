SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_customers_vw] as
select	*
from	EEH.[dbo].[cs_customers_vw] with (READUNCOMMITTED)
GO
