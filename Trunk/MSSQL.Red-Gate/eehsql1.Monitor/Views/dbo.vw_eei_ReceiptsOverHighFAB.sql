SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_ReceiptsOverHighFAB] as
select	*
from	EEH.[dbo].[vw_eei_ReceiptsOverHighFAB] with (READUNCOMMITTED)
GO
