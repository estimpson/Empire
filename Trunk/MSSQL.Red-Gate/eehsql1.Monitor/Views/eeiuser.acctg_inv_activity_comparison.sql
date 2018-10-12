SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [eeiuser].[acctg_inv_activity_comparison] as
select	*
from	eeh.eeiuser.acctg_inv_activity_comparison with (readuncommitted)
GO
