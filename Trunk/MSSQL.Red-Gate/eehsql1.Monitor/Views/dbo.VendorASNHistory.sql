SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VendorASNHistory] as
select	*
from	EEH.[dbo].[VendorASNHistory] with (READUNCOMMITTED)
GO
