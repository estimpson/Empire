SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[ftvwBillOfMaterial]
(	ParentPart,
	ChildPart,
	StdQty )
as
--	Description:
--	Use bill_of_material view because it only pulls current records.
select	ParentPart = parent_part,
	ChildPart = part,
	StdQty = std_qty
from	dbo.bill_of_material
where	IsNull ( std_qty, 0 ) > 0
GO
