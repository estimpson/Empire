SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vendorCopy] as
select	*
from	EEH.[dbo].[vendorCopy] with (READUNCOMMITTED)
GO
