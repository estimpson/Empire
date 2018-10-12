SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[POReceiptPeriodsTemp] as
select	*
from	EEH.[dbo].[POReceiptPeriodsTemp] with (READUNCOMMITTED)
GO
