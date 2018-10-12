SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ft_at_receiptCompare] as
select	*
from	EEH.[dbo].[ft_at_receiptCompare] with (READUNCOMMITTED)
GO
