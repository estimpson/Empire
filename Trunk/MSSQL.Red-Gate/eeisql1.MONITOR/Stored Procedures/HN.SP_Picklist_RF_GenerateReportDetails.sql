SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Declare @R int 
exec HN.SP_Picklist_RF_GenerateReportDetails 'EEI', @r out
*/
/*
Select	ShipperID, 
		TotalLocToVisit= sum(TotalLocToVisit),
		TotalLocBestOption = sum(TotalLocBestOption)
from (
	Select	ShipperId, TotalLocToVisit= count(distinct location), TotalLocBestOption=0
	from	HN.Picklist_RF_LocationDetailTemporal LocToVisit
	group by ShipperId
	union all
	Select	ShipperId, TotalLocToVisit=0, TotalLocBestOption=count(distinct location)
	from	HN.Picklist_RF_LocationDetailTemporal LocToVisit
	where	bestoption=1
	group by ShipperId) data
group by ShipperID

Select	notes, *
from	audit_trail
where	 serial in (36917296,
36221785)
order by serial, date_Stamp

Select	Shipper, Serial, ManualStage= case 
										when remarks='STAGE-BOX' and notes='RFPicklist: Add a box to a shipper' 
											then 0 
										else 1 end
from	audit_trail
where	shipper='105745'

Select	*
from	HN.Picklist_RF_SerialPickedTemporal
*/
CREATE PROC [HN].[SP_Picklist_RF_GenerateReportDetails] (
	@Plant varchar(10)='EEI',
	@Result int output)
as
BEGIN

Declare @ShipperID int,
		@IsFullStandardPack int = 1
	
	DECLARE NombreCursor CURSOR FOR

	Select	ShipperID
	from	[HN].[fn_PickList_ShipperList_ByPlant] (@Plant)
	where	shipperid is not null 

	open NombreCursor
	fetch next from NombreCursor
	into	@ShipperID

		while @@FETCH_STATUS =0
		begin
		
			Delete
			from	HN.Picklist_RF_LocationDetailTemporal
			where	ShipperID =@ShipperID

			Insert into HN.Picklist_RF_LocationDetailTemporal (
				ShipperID, Location, CrossRef, Lot, Available, Part, BestOption, BoxType)
			Select	ShipperID= @ShipperID,
					Location,
					CrossRef,
					Lot = WeekOnStock,
					Available  = convert(varchar,BoxesAvailable) + '/' + convert(varchar,BoxesToPickup),
					Part,
					BestOption,
					BoxType
			from	[HN].[fn_PickList_LocationDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)

			Delete
			from	HN.Picklist_RF_SerialPickedTemporal
			where	ShipperID =@ShipperID

			
			insert into HN.Picklist_RF_SerialPickedTemporal (
				ShipperID, Serial, CrossRef, Part, Quantity, LastDate, standard_pack)
			Select	ShipperID= @ShipperID,
					Serial, CrossRef, obj.Part, Quantity, LastDate = Last_Date, pinv.standard_pack
			from	hn.vw_Picklist_Object obj
					inner join part_inventory  pinv
					on obj.part = pinv.part
			where	plant=@plant
				and isnull(shipper,-1) = @ShipperID
				and [IsFullStdPack]>= @IsFullStandardPack

		fetch next from NombreCursor
		into	@ShipperID

		END
	close NombreCursor
	DEALLOCATE NombreCursor


	Select	ShipperID, 
			Destination,
		TotalLocToVisit= sum(TotalLocToVisit),
		TotalLocBestOption = sum(TotalLocBestOption)
	from (
		Select	ShipperId, TotalLocToVisit= count(distinct location), TotalLocBestOption=0
		from	HN.Picklist_RF_LocationDetailTemporal LocToVisit
		group by ShipperId
		union all
		Select	ShipperId, TotalLocToVisit=0, TotalLocBestOption=count(distinct location)
		from	HN.Picklist_RF_LocationDetailTemporal LocToVisit
		where	bestoption=1
		group by ShipperId) data
	inner join Shipper
		 on Data.ShipperId = Shipper.id
	group by ShipperID, Destination
END


GO
