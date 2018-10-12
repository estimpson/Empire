SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[m_in_customer_po_exceptions] as
select	*
from	EEH.[dbo].[m_in_customer_po_exceptions] with (READUNCOMMITTED)
GO
