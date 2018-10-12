SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [eeiuser].[purchasing_VendorQuoteLog] as
select	*
from	EEH.[eeiuser].[purchasing_VendorQuoteLog] with (READUNCOMMITTED)
GO
