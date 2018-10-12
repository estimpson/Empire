SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwSalesOrderDetail] as
select	*
from	EEH.[FT].[ftvwSalesOrderDetail] with (READUNCOMMITTED)
GO
