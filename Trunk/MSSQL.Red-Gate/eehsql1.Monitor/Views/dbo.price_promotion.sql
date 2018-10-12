SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[price_promotion] as
select	*
from	EEH.[dbo].[price_promotion] with (READUNCOMMITTED)
GO
