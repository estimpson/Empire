SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[RAWVendorASN] as
select	*
from	EEH.[dbo].[RAWVendorASN] with (READUNCOMMITTED)
GO
