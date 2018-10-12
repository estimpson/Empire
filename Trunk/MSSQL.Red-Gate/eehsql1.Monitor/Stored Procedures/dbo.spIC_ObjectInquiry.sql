SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create proc [dbo].[spIC_ObjectInquiry] (@Serial char(12))
as

SELECT object.serial, part.part, part.name, part_inventory.standard_unit, object.operator, Sum(object.quantity) as On_Hand
FROM part INNER JOIN part_inventory ON part_inventory.part=part.part INNER JOIN object ON part.part=object.part
WHERE object.serial like rtrim(ltrim(@Serial)) + '%'
GROUP BY object.serial, part.part, part.name, part_inventory.standard_unit, object.operator 
ORDER BY object.serial 	
GO
