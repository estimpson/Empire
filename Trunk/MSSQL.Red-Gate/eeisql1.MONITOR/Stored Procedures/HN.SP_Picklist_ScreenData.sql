SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [HN].[SP_Picklist_ScreenData]
	(@SelectedTab varchar(25),
	 @ShipperID int ,
	 @Plant varchar(10)='EEI', 
	 @IsFullStandardPack int = 1,
	 @Result int output)
AS
BEGIN


SET nocount ON
set	@Result = 999999
DECLARE @ProcName  sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION @ProcName
	ELSE
		SAVE TRANSACTION @ProcName
--</Tran>
/*
ShipperInfo

ShipperSummary
ShipperDetail
PicklistDetail
PicklistSerial
*/
	If @SelectedTAB='ShipperSummary'
	begin
		Select	CrossRef, 
				Required = BoxesRequired, 
				Picked = BoxesPicked,
				Available = BoxesAvailable,
				Status,				
				Part,
				QtyRequired,
				QtyPicked,
				Comments
		from	[HN].[fn_PickList_ShipperSummary_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	end
		
	If @SelectedTAB='ShipperDetail'
	begin
		Select	CrossRef,
				Lot = WeekOnStock,
				Picked = BoxesPicked,
				Pending = convert(varchar,BoxesPending) + '/' + convert(varchar,BoxesAvailable)
				--Pending = BoxesPending,
				--Available = BoxesAvailable
		from	[HN].[fn_PickList_ShipperDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	end

	If @SelectedTAB='PicklistDetail'
	begin
		Select	Location,
				CrossRef,
				--Available  = convert(varchar,BoxesAvailable) + '/' + convert(varchar,BoxesToPickup),
				LocQty= BoxesAvailable,
				LotReq = BoxesToPickup,
				Lot = WeekOnStock,
				Part,
				BestOption,
				BoxType
		from	[HN].[fn_PickList_LocationDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	end

	--Requiered= BoxesToPickup
	--AvialByLot= BoxesAvailable

	If @SelectedTAB='PicklistSerial'
	begin
		Select	*
		from	[HN].[fn_PickList_SerialDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	end

	
	If @SelectedTAB='SerialPicked'
	begin
		Select	Serial, CrossRef, obj.Part, Quantity, LastDate = Last_Date, pinv.standard_pack
		from	hn.vw_Picklist_Object obj
			 inner join part_inventory  pinv
			  on obj.part = pinv.part
		where	plant=@plant
			and isnull(shipper,-1) = @ShipperID
		--	and [IsFullStdPack]>= @IsFullStandardPack
		order by Last_Date desc
	end

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
END


GO
