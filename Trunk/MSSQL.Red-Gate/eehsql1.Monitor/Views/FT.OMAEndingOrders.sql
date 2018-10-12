SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMAEndingOrders] as
select	*
from	EEH.[FT].[OMAEndingOrders] with (READUNCOMMITTED)
GO
