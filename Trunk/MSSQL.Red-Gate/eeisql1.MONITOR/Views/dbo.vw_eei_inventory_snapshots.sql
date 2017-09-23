SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_inventory_snapshots] as

Select serial, part, quantity from object_copy_20060131
UNION 
Select  serial, part, quantity from object_copy_20060131
UNION
Select  serial, part, quantity from object_copy_20060331
UNION 
Select  serial, part, quantity from object_copy_20060430
UNION
Select  serial, part, quantity from object_copy_20060531
UNION 
Select  serial, part, quantity from object_copy_20060630
UNION
select serial, part,quantity from object


GO
