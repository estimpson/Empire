SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[bill_of_material_ec] as
select	*
from	EEH.[dbo].[bill_of_material_ec] with (READUNCOMMITTED)
GO
