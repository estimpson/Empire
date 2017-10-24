SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [HN].[fn_PickList_ShipperSummary_ByShipper]
(	@ShipperID int
,	@Plant varchar(10) = 'EEI'
,	@IsFullStandardPack int = 1
,	@Part varchar(25) = null
)
returns @Objects table
(	ShipperID int
,	CrossRef varchar(50)
,	Part varchar(25)
,	QtyRequired int
,	StandardPack int 
,	BoxesAvailable int
,	BoxesRequired int
,	BoxesPicked int
,	[Status] varchar(15)
,	Comments varchar(1000)
,	QtyPicked int
)
as 
begin

if @Part is null 
begin
	insert
		@Objects
	(	ShipperID
	,	CrossRef
	,	Part
	,	QtyRequired
	,	StandardPack
	,	BoxesAvailable
	,	BoxesRequired
	,	BoxesPicked
	,	[Status]
	,	Comments
	,	QtyPicked
	)
	Select	Detail.Shipper,
		CrossRef = Part.Cross_Ref,
		Detail.Part,
		QtyRequired = convert(int, Qty_Required),		
		StandardPack = convert(int, Part_Inventory.Standard_Pack),
		BoxesAvailable = convert(int, isnull(QtyAvailable,0) / (Part_Inventory.Standard_Pack *1.0)),
		BoxesRequired = ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0)),		
		BoxesPicked = isnull(BoxOnShipper,0), --convert(int, isnull(QtyOnShipper,0) / (Part_Inventory.Standard_Pack *1.0)),
		--[Status] = case 
		--				when isnull(BoxOnShipper,0) < ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
		--					then 'Incomplete'
		--				when isnull(BoxOnShipper,0) > ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
		--					then 'Overage'
		--					else 'Complete' end,
		Status = case 
						when isnull(BoxOnShipper,0) = ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							and  isnull(Qty_Required,0) =  isnull(QtyOnShipper,0) then 'Complete'
						when isnull(BoxOnShipper,0) >= ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							or isnull(QtyOnShipper,0)  > isnull(Qty_Required,0)  then 'Overstage'
						when isnull(BoxOnShipper,0) < ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							or  isnull(QtyOnShipper,0) < isnull(Qty_Required,0)    then 'Incomplete'
						end,
			   
		Comments = case 
					when (Qty_Required /( Part_Inventory.Standard_Pack*1.0)) - (convert(int,Qty_Required) / convert(int,Part_Inventory.Standard_Pack)) >0 
						then 'It is necessary to break the standard pack of one box or please confirm if the Qty Required is OK. ' 
					else '' end +  
				   case 
					when (convert(int, Qty_Required / (Part_Inventory.Standard_Pack *1.0)) > convert(int, isnull(QtyAvailable,0) / (Part_Inventory.Standard_Pack *1.0))
						and isnull(BoxOnShipper,0) <> ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))) or (convert(int, isnull(QtyAvailable,0) / (Part_Inventory.Standard_Pack *1.0)))=0
					  then 'Not enough boxes in stock to complete the requirement. '
					  else '' end + 
					case when isnull(BoxOnShipper,0) <> ceiling(Qty_Required / (Part_Inventory.Standard_Pack *1.0)) and
						isnull(QtyOnShipper,0) >=convert(int, Qty_Required)
						then 'Fix standard pack issue to display more serials. ' else '' end,
		QtyOnShipper = isnull(QtyOnShipper,0)
from	shipper_detail Detail
	inner join Part
		on Detail.Part = Part.Part
	inner join Part_Inventory
		on Part.Part = Part_Inventory.PArt
	left join (
				Select	Part,
						QtyOnShipper = sum(QtyOnShipper ),
						QtyAvailable = sum(QtyAvailable),
						BoxOnShipper = sum(BoxOnShipper )
				from (
					Select	Part, 
							QtyOnShipper = CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN sum(quantity) ELSE 0 END,
							QtyAvailable = CASE WHEN ISNULL(SHIPPER,-1) =-1 THEN sum(quantity) ELSE 0 END,
							BoxOnShipper = 	CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN count(1) ELSE 0 END			
					from HN.vw_Picklist_Object
					where plant = @Plant and IsFullStdPack >= @IsFullStandardPack
					group by shipper, part) PartStage
				group by Part					
			  ) SerialStage 
		on SerialStage.Part = Detail.part			
where Detail.Shipper= @ShipperID
end else begin

insert
		@Objects
	(	ShipperID
	,	CrossRef
	,	Part
	,	QtyRequired
	,	StandardPack
	,	BoxesAvailable
	,	BoxesRequired
	,	BoxesPicked
	,	[Status]
	,	Comments
	,	QtyPicked
	)
	Select	Detail.Shipper,
		CrossRef = Part.Cross_Ref,
		Detail.Part,
		QtyRequired = convert(int, Qty_Required),		
		StandardPack = convert(int, Part_Inventory.Standard_Pack),
		BoxesAvailable = convert(int, isnull(QtyAvailable,0) / (Part_Inventory.Standard_Pack *1.0)),
		BoxesRequired = ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0)),		
		BoxesPicked = isnull(BoxOnShipper,0), --convert(int, isnull(QtyOnShipper,0) / (Part_Inventory.Standard_Pack *1.0)),
		--[Status] = case 
		--				when isnull(BoxOnShipper,0) < ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
		--					then 'Incomplete'
		--				when isnull(BoxOnShipper,0) > ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
		--					then 'Overage'
		--					else 'Complete' end,
		Status = case 
						when isnull(BoxOnShipper,0) = ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							and  isnull(Qty_Required,0) =  isnull(QtyOnShipper,0) then 'Complete'
						when isnull(BoxOnShipper,0) >= ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							or isnull(QtyOnShipper,0)  > isnull(Qty_Required,0)  then 'Overstage'
						when isnull(BoxOnShipper,0) < ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
							or  isnull(QtyOnShipper,0) < isnull(Qty_Required,0)    then 'Incomplete'
						end,
			   
		Comments = case 
					when (Qty_Required /( Part_Inventory.Standard_Pack*1.0)) - (convert(int,Qty_Required) / convert(int,Part_Inventory.Standard_Pack)) >0 
						then 'It is necessary to break the standard pack of one box or please confirm if the Qty Required is OK ' 
					else '' end +  
				   case 
					when convert(int, Qty_Required / (Part_Inventory.Standard_Pack *1.0)) > convert(int, isnull(QtyAvailable,0) / (Part_Inventory.Standard_Pack *1.0))
						and isnull(BoxOnShipper,0) <> ceiling( Qty_Required / (Part_Inventory.Standard_Pack *1.0))
					  then 'Not enough boxes in stock to complete the requirement. '
					  else '' end + 
					case when isnull(BoxOnShipper,0) <> ceiling(Qty_Required / (Part_Inventory.Standard_Pack *1.0)) and
						isnull(QtyOnShipper,0) >=convert(int, Qty_Required)
						then 'Fix standard pack issue to display more serials.' else '' end,
		QtyOnShipper = isnull(QtyOnShipper,0)
from	shipper_detail Detail with (readuncommitted)
	inner join Part with (readuncommitted)
		on Detail.Part = Part.Part
	inner join Part_Inventory with (readuncommitted)
		on Part.Part = Part_Inventory.PArt
	left join (
				Select	Part,
						QtyOnShipper = sum(QtyOnShipper ),
						QtyAvailable = sum(QtyAvailable),
						BoxOnShipper = sum(BoxOnShipper )
				from (
					Select	Part, 
							QtyOnShipper = CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN sum(quantity) ELSE 0 END,
							QtyAvailable = CASE WHEN ISNULL(SHIPPER,-1) =-1 THEN sum(quantity) ELSE 0 END,
							BoxOnShipper = 	CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN count(1) ELSE 0 END			
					from HN.vw_Picklist_Object with (readuncommitted)
					where plant = @Plant and IsFullStdPack >= @IsFullStandardPack and part= @Part
					group by shipper, part) PartStage
				group by Part					
			  ) SerialStage 
		on SerialStage.Part = Detail.part			
where Detail.Shipper= @ShipperID and detail.part= @Part

end
	return
end
	
	
GO
