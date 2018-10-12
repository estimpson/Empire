SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer_additional] as
select	*
from	EEH.[dbo].[customer_additional] with (READUNCOMMITTED)
GO
