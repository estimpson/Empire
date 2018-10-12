SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_ScanIdentifiers] as
select	*
from	EEH.[dbo].[FTRF_ScanIdentifiers] with (READUNCOMMITTED)
GO
