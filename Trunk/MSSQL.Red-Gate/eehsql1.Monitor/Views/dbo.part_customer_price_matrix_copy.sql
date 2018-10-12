SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_customer_price_matrix_copy] as
select	*
from	EEH.[dbo].[part_customer_price_matrix_copy] with (READUNCOMMITTED)
GO
