SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [dbo].[vw_eei_Lost_trans]
as
Select	last_date,
	Serial,
	Object.Part,
	Std_quantity,
	Location,
	Status,
	isNULL(std_quantity*cost_cum,0) as ObjectMaterialCost
from	object
join	part_standard on object.part = part_standard.part 
where	location like '%TRAN%' and 
	datediff(dd, last_date, getdate()) > 30 and
	object.part!= 'pallet'
GO
