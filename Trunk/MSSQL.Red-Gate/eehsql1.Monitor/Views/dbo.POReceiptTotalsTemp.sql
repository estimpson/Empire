SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[POReceiptTotalsTemp] as
select	*
from	EEH.[dbo].[POReceiptTotalsTemp] with (READUNCOMMITTED)
GO
