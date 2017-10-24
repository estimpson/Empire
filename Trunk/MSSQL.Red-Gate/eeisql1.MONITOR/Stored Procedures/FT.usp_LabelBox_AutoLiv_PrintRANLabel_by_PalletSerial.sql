SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [FT].[usp_LabelBox_AutoLiv_PrintRANLabel_by_PalletSerial]
	@PalletSerial INT
,	@Customerpart VARCHAR(30)
,	@RANNumber VARCHAR(50)
,	@ShipWindow VARCHAR(50) = ''											
,	@TranDT DATETIME = NULL OUT
,	@Result INTEGER = NULL OUT
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
	RAISERROR ('Error assigning RAN to serial %d.  This Pallet must be staged to a shipper.', 16, 1, @PalletSerial)
	ROLLBACK TRAN @ProcName
	RETURN
END
---	</ArgumentValidation>




--Select * From @OpenReleases
--Select * From @StagedInventory
	
		
--Get Data for Label

--Declare Table Variable To Store Label Data to Send to Bartender

DECLARE @LabelData TABLE
(	CustomerPart VARCHAR(50)
,	ObjectSerial INT
,	ObjectParentSerial INT
,	PartName VARCHAR(255)
,	Quantity INT
,	RAN VARCHAR(50)
,	SupplierCode VARCHAR(50)
,	RevLevel VARCHAR(50)
,	DockCode VARCHAR(50)
,	LineFeedCode VARCHAR(50)
,	ShipWindow VARCHAR(50)
, --Still need to write this to object from order_detail
	MfgDate DATETIME
,	ShipTo VARCHAR(50)
,	CompanyName VARCHAR(50)
,	CompanyAdd1 VARCHAR(50)
,	CompanyAdd2 VARCHAR(50)
,	CompanyAdd3 VARCHAR(50)
)

INSERT
	@LabelData
SELECT
    sd.customer_part AS CustomerPart
,   o.serial AS ObjectSerial
,   o.parent_serial AS ObjectParentSerial
,   p.name AS PartName
,   o.quantity AS Quantity
,   o.custom1 AS RAN
,   es.supplier_code AS SupplierCode
,   oh.engineering_level AS RevLevel
,   oh.dock_code AS DockCode
,   oh.line_feed_code AS LineFeedCode
,   o.custom5 AS ShipWindow
, --Still need to write this to object from order_detail
    (COALESCE((
               SELECT
                MIN(MfgDT)
               FROM
                FT.CommonSerialShipLog
               WHERE
                serial = o.serial
              ), DATEADD(dd, -30, GETDATE()))) AS MfgDate
,   RIGHT(COALESCE(NULLIF(es.parent_destination, ''), NULLIF(es.parent_destination, ''), es.destination), 3) AS ShipTo
,   parms.company_name AS CompnyName
,   parms.address_1 AS CompnyAdd1
,   parms.address_2 AS CompnyAdd2
,   parms.address_3 AS CompnyAdd3
FROM
    object o
    JOIN shipper s
        ON s.id = o.shipper
    JOIN shipper_detail sd
        ON sd.shipper = s.id
           AND sd.part_original = o.part
    JOIN order_header oh
        ON oh.order_no = sd.order_no
    JOIN part p
        ON p.part = o.part
    JOIN edi_setups es
        ON es.destination = s.destination
    CROSS JOIN parameters parms
WHERE
    o.parent_serial = @PalletSerial AND
	sd.customer_part =  @Customerpart

SELECT
    LabelData.CustomerPart
,   LabelData.ObjectSerial
,   LabelData.ObjectParentSerial
,   LabelData.PartName
,   LabelData.Quantity
,   RANNumber = @RANNumber
,   LabelData.SupplierCode
,   LabelData.RevLevel
,   LabelData.DockCode
,   LabelData.LineFeedCode
,   ShipWindow = @ShipWindow
,   LabelData.MfgDate
,   LabelData.ShipTo
,   LabelData.CompanyName
,   LabelData.CompanyAdd1
,   LabelData.CompanyAdd2
,   LabelData.CompanyAdd3
FROM
    @LabelData LabelData
ORDER BY
   LabelData.CustomerPart
,   LabelData.ObjectSerial
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
	@PalletSerial int,
	@RANNumber varchar(25),
	@ShipWindow varchar(25)

set	@PalletSerial = 1382720
set	@RANNumber = '1234567890'
set	@ShipWindow = '0099'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = ft.usp_LabelBox_AutoLiv_PrintRANLabel_by_PalletSerial
	@PalletSerial = @PalletSerial
,	@RANNumber = @RANNumber
,	@ShipWindow = @ShipWindow

,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult


go

if	@@trancount > 0 begin
	commit
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
