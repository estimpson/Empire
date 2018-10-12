SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEIProblemReceiptPeriods] as
select	*
from	EEH.[dbo].[EEIProblemReceiptPeriods] with (READUNCOMMITTED)
GO
