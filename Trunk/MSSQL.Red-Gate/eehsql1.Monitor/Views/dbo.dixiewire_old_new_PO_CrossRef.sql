SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixiewire_old_new_PO_CrossRef] as
select	*
from	EEH.[dbo].[dixiewire_old_new_PO_CrossRef] with (READUNCOMMITTED)
GO
