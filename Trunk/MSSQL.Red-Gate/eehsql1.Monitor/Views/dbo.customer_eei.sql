SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer_eei] as
select	*
from	EEH.[dbo].[customer_eei] with (READUNCOMMITTED)
GO
