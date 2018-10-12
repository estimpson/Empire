SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[bill_of_material_ec_old] as
select	*
from	EEH.[dbo].[bill_of_material_ec_old] with (READUNCOMMITTED)
GO
