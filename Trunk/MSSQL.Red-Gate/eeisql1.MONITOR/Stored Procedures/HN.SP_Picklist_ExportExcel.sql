SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec HN.SP_Picklist_ExportExcel 'EC',

CREATE PROC [HN].[SP_Picklist_ExportExcel]
	(@Operator varchar(25),
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

	
	Delete
	from	HN.Picklist_RF_DataExcel
	where	operator=@operator and ShipperID = @ShipperID

	insert
		HN.Picklist_RF_DataExcel
	(	Operator
	,	ShipperID
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
	,	TAB
	)

		Select	@Operator, 
				ShipperID
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
			,	TAB='ShipperSummary'
		from	[HN].[fn_PickList_ShipperSummary_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)

		
	
	insert
		HN.Picklist_RF_DataExcel
	(	Operator
	,	ShipperID
	,	CrossRef
	,	lot
	,	QtyPicked
	,	Pending
	,	TAB
	)

		Select	@Operator, 
				@ShipperID,
				CrossRef,
				Lot = WeekOnStock,
				Picked = BoxesPicked,
				Pending = convert(varchar,BoxesPending) + '/' + convert(varchar,BoxesAvailable)
				, TAB = 'ShipperDetail'
		from	[HN].[fn_PickList_ShipperDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	
	
	insert into
		HN.Picklist_RF_DataExcel
	(	Operator
	,	ShipperID
	,	Location
	,	CrossRef
	,	LocQty
	,	LotReq
	,	LOT
	,	Part
	,	BestOption
	,	BoxType
	,	TAB
	)
		Select	@Operator,
				@ShipperID,
				Location,
				CrossRef,
				LocQty= BoxesAvailable,
				LotReq = BoxesToPickup,
				Lot = WeekOnStock,
				Part,
				BestOption,
				BoxType
				, TAB = 'PicklistDetail'
		from	[HN].[fn_PickList_LocationDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)
	
	Select 	ShipperID
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
	from HN.Picklist_RF_DataExcel
	where	operator=@operator
		and shipperid=@shipperid
		and tab='ShipperSummary'
	
	
	
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
