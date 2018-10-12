SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VendorASNsWaitingforReview] as
select	*
from	EEH.[dbo].[VendorASNsWaitingforReview] with (READUNCOMMITTED)
GO
