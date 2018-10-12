SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[VendorQuoteLog] as
select	*
from	EEH.[dbo].[VendorQuoteLog] with (READUNCOMMITTED)
GO
