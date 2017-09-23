SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Select	*
from	[HN].[fn_PickList_LocationDetail_ByShipper](105746,'EEI',1,NULL)
order by part, weekonstock
*/
CREATE function [HN].[fn_PickList_LocationDetail_ByShipper]
(	@ShipperID int
,	@Plant varchar(10) = 'EEI'
,	@IsFullStandardPack int = 1
,	@Part varchar(25) = null
)	
returns @Objects table
(	Location varchar(25)
,	BoxesAvailable int
,	CrossRef varchar(50)
,	WeekOnStock int
,	BoxesToPickUp int
,	Part varchar(25)
,	BestOption int
,	BoxType varchar(25)
)
as 
begin

Insert into @Objects
Select	Object.location,
		BoxesAvailable = count(object.serial),
		Object.CrossRef, 
		Object.weeks_on_stock,		
		BoxesToPick = ShipperDetail.BoxesPending,		
		Object.Part , 0, BoxType= isnull(PartPack.code,'N/D')
from	[HN].[fn_PickList_ShipperDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack, @Part) ShipperDetail
	inner join hn.vw_picklist_object Object
		 on ShipperDetail.Part = object.part
			and ShipperDetail.weekonstock = object.weeks_on_stock
			and ShipperDetail.CrossRef = Object.CrossRef
			and object.plant=@Plant and object.location not like '%stage%' and IsFullStdPack>= @IsFullStandardPack
	left join part_packaging PartPack
		 on PartPack.part = object.part
where	ShipperDetail.BoxesPending>0
group by 	Object.location,
		Object.CrossRef, 
		ShipperDetail.BoxesPending,
		Object.Part, 
		Object.weeks_on_stock,
		isnull(PartPack.code,'N/D')
order by  Object.location, Object.weeks_on_stock desc, Object.CrossRef
--order by isnull(PartPack.code,'N/D'), Object.location, Object.weeks_on_stock desc, Object.CrossRef

declare @ObjectsTemp table
(	id int identity(1,1)
,	Location varchar(25)
,	BoxesAvailable int
,	CrossRef varchar(50)
,	WeekOnStock int
,	BoxesToPickUp int
,	Part varchar(25)
)

Insert into @ObjectsTemp
Select	Location, BoxesAvailable, CrossRef, WeekOnStock, BoxesToPickUp, Part
from	@Objects
order by Part, CrossRef, WeekOnStock, BoxesAvailable desc


update @Objects
set BestOption =1 
from @Objects obj
	 inner join	(
		Select	ValorOriginal.WeekOnStock,
				valororiginal.BoxesToPickUp,
				ValorOriginal.location,
				AvailableAcum = isnull(sum(valoracum.BoxesAvailable),0)
		from	@ObjectsTemp ValorOriginal
			left join @ObjectsTemp ValorAcum
			  on ValorAcum.Part = ValorOriginal.part
					and ValorAcum.WeekOnStock = ValorOriginal.WeekOnStock
					and ValorAcum.ID < ValorOriginal.ID
		group by 
				ValorOriginal.WeekOnStock,
				valororiginal.BoxesToPickUp,
				ValorOriginal.location	
				
				) data
		on obj.WeekOnStock = data.WeekOnStock
			and obj.Location = data.Location			
			and obj.BoxesToPickUp = data.BoxesToPickUp
where	data.AvailableAcum<data.BoxesToPickUp 

	return
end

GO
