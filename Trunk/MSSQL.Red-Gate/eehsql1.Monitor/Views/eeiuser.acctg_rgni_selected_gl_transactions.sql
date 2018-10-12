SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create view [eeiuser].[acctg_rgni_selected_gl_transactions] as
select	*
from	EEH.[eeiuser].[acctg_rgni_selected_gl_transactions] with (READUNCOMMITTED)


GO
