SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [eeiuser].[acctg_inv_age_allowance] as
	select * from eeh.eeiuser.acctg_inv_age_allowance with (Readuncommitted)


GO
