SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[usp_LabelPallet_AutoLiv_by_PalletSerialCustpartRANSWQty]
	@PalletSerial INT
,	@Customerpart VARCHAR(50)
,	@RANNumber VARCHAR(25)
,	@ShipWindow VARCHAR(25) = ''
,	@PartRANQty INT
,	@tranDT DATETIME = NULL OUT
,	@result INTEGER = NULL OUT
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	@Result = 999999

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
ELSE BEGIN
	SAVE TRAN @ProcName
END
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

	/*	Object serial must be staged to a shipper. */

IF	NOT EXISTS
	(	SELECT
			*
		FROM
			dbo.object o
		WHERE
			COALESCE(parent_serial,0) = @PalletSerial AND
			COALESCE(shipper,0) > 0
		
	) BEGIN
	
	SET	@Result = 999999
	RAISERROR ('Error Printing RANs for shipper %d.  This serials must be staged to a shipper.', 16, 1, @PalletSerial)
	ROLLBACK TRAN @ProcName
	RETURN
END
---	</ArgumentValidation>

--- <Body>
	
	--Get Data for Label

	--Declare Table Variable To Store Label Data to Send to Bartender

	DECLARE @LabelData TABLE
(
		CustomerPart VARCHAR(50),
		ObjectParentSerial INT,
		Quantity INT,
		SupplierCode VARCHAR(25),
		DockCode VARCHAR(25),
		LineFeedCode VARCHAR(25),
		ShipWindow VARCHAR(25),
		ShipTo VARCHAR(25),
		RAN VARCHAR(50)
)



INSERT @LabelData
	SELECT 
		Distinct
		CustomerPart = @Customerpart,
		o.parent_serial AS ObjectParentSerial,
		Quantity = @PartRANQty,
		es.supplier_code AS SupplierCode,
		COALESCE(oh.dock_code,'') AS DockCode,
		COALESCE(oh.line_feed_code, '') AS LineFeedCode,
		ShipWindow = @ShipWindow, 
		RIGHT(COALESCE(NULLIF(es.parent_destination,''),NULLIF(es.parent_destination,''), es.destination ),3) AS ShipTo,
		RAN = @RANNumber
				
	FROM
		object o	
	JOIN
		shipper s ON s.id = o.shipper
	JOIN
		shipper_detail sd ON sd.shipper = s.id
		AND sd.part_original =  o.part
	JOIN
		order_header oh ON oh.order_no = sd.order_no
	JOIN
		part p ON p.part = o.part
	JOIN
		edi_setups es ON es.destination = s.destination
	-- following join added to limit the query to one row when multiple orders are on a shipper - CAD 4/8/2016
	join
		(	select
				max(order_no) as order_no
			from
				object o	
			join shipper s 
				on s.id = o.shipper
			join shipper_detail sd 
				on sd.shipper = s.id
				and sd.part_original =  o.part
			where
				coalesce(o.parent_serial,0) = @PalletSerial ) as sub
		on sd.order_no = sub.order_no
	WHERE 
		COALESCE(o.parent_serial,0) = @PalletSerial

	

SELECT * FROM @LabelData LabelData

	

--- </Body>

---	<Return>
SET	@Result = 0
RETURN
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@PalletSerial INT
,	@Customerpart VARCHAR(50)
,	@RANNumber VARCHAR(25)
,	@ShipWindow VARCHAR(25) = ''
,	@PartRANQty INT

set	@PalletSerial = 1382720
set	@CustomerPart = '625264800G'
set @RANNumber = '1234567890'
set @ShipWindow  = '0101'
Set @PartRANQty = 999

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = ft.usp_LabelPallet_AutoLiv_by_PalletSerialCustpartRANSWQty
	@PalletSerial = @PalletSerial
,	@Customerpart = @Customerpart
,	@RANNumber = @RANNumber
,	@ShipWindow = @ShipWindow
,	@PartRANQty = @PartRANQty
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult


go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/






GO
