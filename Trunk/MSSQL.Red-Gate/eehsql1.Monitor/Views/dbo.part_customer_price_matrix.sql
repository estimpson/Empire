SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_customer_price_matrix] as
select	*
from	EEH.[dbo].[part_customer_price_matrix] with (READUNCOMMITTED)
GO
