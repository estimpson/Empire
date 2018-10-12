SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[bill_of_material] as
select	*
from	EEH.[dbo].[bill_of_material] with (READUNCOMMITTED)
GO
