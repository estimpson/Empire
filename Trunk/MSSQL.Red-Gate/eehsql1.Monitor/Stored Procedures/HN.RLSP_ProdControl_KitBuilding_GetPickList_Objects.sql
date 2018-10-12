SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [HN].[RLSP_ProdControl_KitBuilding_GetPickList_Objects]
as 
begin

--Declare @Cortos table(
--	Materialist varchar(5),
--	Part varchar(25),
--	Color varchar(35),
--	QtyShort int,
--	Machine varchar(25))

	
--Insert into @Cortos
--Select	Materialist, Component, Color, QtyShort, Machine 
--FROM    EEH.HN.fn_ProdControl_KITBuilding_GetPicklist_byWareHouse(NULL)
--where QtyShort>0

create table #Cortos 
	(	Machine varchar (10),
		Part varchar (25),
		QtySchedThisWeek int,
		RequiredFromNextWeek int,
		QtyRequiredThroughMinOnHandDT int,
		QtyRequiredThroughEndDT int,
		QtyCompletedThisWeek int,
		MinOnHandDT datetime,
		EndDT datetime,
		QtyNetRequiredThroughMinOnHandDT int,
		QtyNetRequiredThroughEndDT int,
		Component varchar(25),
		Color varchar(20),
		Warehouse varchar(25),
		Materialist varchar(5),
		MaterialistCount int,
		BOMQty numeric(20,6),
		StandardUnit varchar(2),
		ConversionFactor numeric(20,6),
		DisplayUnit varchar(2),
		QtyInAssembly int,
		QtyInLine int,
		QtyInPotting int,
		QtyInMolding int,
		QtyInInventory int,
		QtyTotalInventory int,
		QtyExcess int,
		QtyShort int,
		QtyInTransit int,
		GroupTech varchar(25)  )


insert into #Cortos
exec EEH.HN.SP_MAT_ProdControl_KITBuilding_GetPicklist_byWareHouse

Declare @CortosInventario table(
	Materialist varchar(5),
	Part varchar(25),
	Color varchar(35),
	QtyShort int,
	serial int,
	location varchar(25),
	std_quantity int,
	Machine varchar(25),
	GroupTech varchar(25))

Insert into @CortosInventario
SELECT     TOP (100) PERCENT Shorts.Materialist, Shorts.Component AS Part, Shorts.Color, Shorts.QtyShort, dbo.object.serial, dbo.object.location, dbo.object.std_quantity, 
                      Shorts.Machine, location.group_no
FROM         #Cortos AS Shorts INNER JOIN
                      dbo.object WITH (readuncommitted) ON Shorts.Component = dbo.object.part AND dbo.object.status = 'A'
  inner join dbo.location location on location.code =dbo.object.location
WHERE     (group_no IN ('corte-komax', 'Corte-Sonica-Kits', 'Corte-Troqmanual-Kits', 'Bodega - Corte', 'BODEGA-SPL','INVENTARIO') AND (Shorts.QtyShort > 0)) AND 
                      EXISTS
                          (SELECT     1 AS Expr1
                            FROM          dbo.object AS obj WITH (readuncommitted) INNER JOIN
                                                   dbo.location AS location_1 ON obj.location = location_1.code
                            WHERE      (location_1.group_no IN ('corte-komax', 'Corte-Sonica-Kits', 'Corte-Troqmanual-Kits', 'Bodega - Corte', 'BODEGA-SPL','INVENTARIO')) AND (obj.part = Object.part) AND 
                                                   (obj.serial <= Object.Serial) AND (obj.status = 'A')
                            HAVING      (SUM(obj.std_quantity) <= Shorts.QtyShort + Object.std_quantity))
ORDER BY Part

--WHERE     (dbo.object.location IN
--                          (SELECT     code
--                            FROM          dbo.location
--                            WHERE      (group_no IN ('corte-komax', 'Corte-Sonica-Kits', 'Corte-Troqmanual-Kits', 'Bodega - Corte', 'BODEGA-SPL')))) AND (Shorts.QtyShort > 0) AND 


Select * from @CortosInventario
union all
Select	Materialist,
		part = Component,
		Color,
		QtyShort,
		serial=0,
		location='',
		std_quantity='',		
		Machine,
		GroupTech=''		 
from	#Cortos
where	Component not in (Select distinct part from @CortosInventario)
		AND QtyShort > 0


end
GO
