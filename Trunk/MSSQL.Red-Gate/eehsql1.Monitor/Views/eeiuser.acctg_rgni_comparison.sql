SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [eeiuser].[acctg_rgni_comparison] as
select	*
from	EEH.[eeiuser].[acctg_rgni_comparison] with (READUNCOMMITTED)

GO
