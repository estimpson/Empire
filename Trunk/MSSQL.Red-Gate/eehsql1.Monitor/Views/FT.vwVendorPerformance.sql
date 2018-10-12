SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwVendorPerformance] as
select	*
from	EEH.[FT].[vwVendorPerformance] with (READUNCOMMITTED)
GO
