SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [FT].[usp_LabelPallet_Valeo_by_Shipper]


	@shipper INT
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
			1
		FROM
			dbo.object o
		WHERE
			COALESCE(shipper,0) = @Shipper
			UNION
		SELECT
			1
		FROM
			dbo.audit_trail at
		WHERE
			COALESCE(shipper,'0') = convert(varchar(25), @Shipper )
			AND type = 'S'
	) 
	
	
	
	
	BEGIN
	
	SET	@Result = 999999
	RAISERROR ('Error Printing Labels for shipper %d.  This serials must be staged to a shipper a pallet on shipper %d.', 16, 1, @shipper)
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
		ObjectPartMasterSerial INT,
		Quantity INT,
		SupplierCode VARCHAR(25),
		DockCode VARCHAR(25),
		LineFeedCode VARCHAR(25),
		ShipWindow VARCHAR(25),
		ShipTo VARCHAR(25),
		DestName varchar(100),
		DestAdd1 varchar(100),
		DestAdd2 varchar(100),
		DestAdd3 varchar(100),
		ParmsName varchar(100),
		ParmsAdd1 varchar(100),
		ParmsAdd2 varchar(100),
		ParmsAdd3 varchar(100),
		PartCount int,
		ShipperID int,
		PartName varchar(255)
)



INSERT @LabelData
	SELECT 
		sd.customer_part AS CustomerPart,
		o.parent_serial AS ObjectParentSerial,
		FirstPartMasterSerial as ObjectPartMasterSerial,
		--0 as ObjectPartMasterSerial,
		SUM(o.quantity) AS Quantity,
		COALESCE(nullif(es.supplier_code,''), 'FixSupplierCode') AS SupplierCode,
		max(COALESCE(oh.dock_code,'')) AS DockCode,
		max(COALESCE(oh.line_feed_code, '')) AS LineFeedCode,
		max(COALESCE(o.custom5,'')) AS ShipWindow, --need to define on inbound data processing
		RIGHT(COALESCE(NULLIF(es.ediShipToID,''),NULLIF(es.parent_destination,''), es.destination ),10) AS ShipTo,
		d.name as DestName,
		d.address_1 as DestAdd1,
		d.address_2 as DestAdd2,
		d.address_3 as DestAdd3,
		parms.company_name as ParmsCoName,
		parms.address_1 as ParmsAdd1,
		parms.address_2 as ParmsAdd2,
		parms.address_3 as ParmsAdd3,
		COUNT(distinct o.part),
		s.id,
		p.name
				
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
JOIN
	destination d on d.destination = s.destination
outer apply
	( select top 1 serial*10 as FirstPartMasterSerial from object o2 where o2.shipper = s.id  and o2.part = sd.part_original and o2.parent_serial = o.parent_serial order by o2.serial ) as FirstPartSerial
CROSS JOIN parameters parms
		WHERE 
		o.shipper = @shipper AND
		COALESCE(o.parent_serial,0) > 0 
GROUP BY
		sd.customer_part,
		o.parent_serial,
		FirstPartMasterSerial,
		COALESCE(nullif(es.supplier_code,''), 'FixSupplierCode'),
		RIGHT(COALESCE(NULLIF(es.ediShipToID,''),NULLIF(es.parent_destination,''), es.destination ),10),
		d.name,
		d.address_1 ,
		d.address_2,
		d.address_3,
		parms.company_name ,
		parms.address_1 ,
		parms.address_2 ,
		parms.address_3,
		s.id,
		p.name
	
		
UNION

	SELECT 
		sd.customer_part AS CustomerPart,
		at.parent_serial AS ObjectParentSerial,
		FirstPartMasterSerial as ObjectPartMasterSerial,
		SUM(at.quantity) AS Quantity,
		COALESCE(nullif(es.supplier_code,''), 'FixSupplierCode') AS SupplierCode,
		max(COALESCE(oh.dock_code,'')) AS DockCode,
		max(COALESCE(oh.line_feed_code, '')) AS LineFeedCode,
		max(COALESCE(at.custom5,'')) AS ShipWindow, --need to define on inbound data processing
		RIGHT(COALESCE(NULLIF(es.ediShipToID,''),NULLIF(es.parent_destination,''), es.destination ),10) AS ShipTo,
		d.name as DestName,
		d.address_1 as DestAdd1,
		d.address_2 as DestAdd2,
		d.address_3 as DestAdd3,
		parms.company_name as ParmsCoName,
		parms.address_1 as ParmsAdd1,
		parms.address_2 as ParmsAdd2,
		parms.address_3 as ParmsAdd3,
		COUNT(distinct at.part),
		s.id,
		p.name
				
	FROM
		audit_trail at	
	JOIN
		shipper s ON convert(varchar(25), s.id ) = at.shipper
	JOIN
		shipper_detail sd ON sd.shipper = s.id
		AND sd.part_original = at.part
	JOIN
		order_header oh ON oh.order_no = sd.order_no
	JOIN
		part p ON p.part = at.part
JOIN
		edi_setups es ON es.destination = s.destination
JOIN
	destination d on d.destination = s.destination
outer apply
	( select top 1 serial*10 as FirstPartMasterSerial from audit_trail at2 where at2.shipper = convert(varchar(25), s.id ) and at2.type = 'S' and at2.part = sd.part_original and at2.parent_serial = at.parent_serial order by at2.serial ) as FirstPartSerial
	CROSS JOIN parameters parms
		WHERE 
		at.shipper = convert(varchar(25),@Shipper )AND
		COALESCE(at.parent_serial,0) > 0  and
		at.type = 'S'
GROUP BY
		sd.customer_part,
		at.parent_serial,
		FirstPartMasterSerial,
		COALESCE(nullif(es.supplier_code,''), 'FixSupplierCode'),
		RIGHT(COALESCE(NULLIF(es.ediShipToID,''),NULLIF(es.parent_destination,''), es.destination ),10),
		d.name,
		d.address_1 ,
		d.address_2,
		d.address_3,
		parms.company_name ,
		parms.address_1 ,
		parms.address_2 ,
		parms.address_3,
		s.id,
		p.name
	
	

SELECT * FROM @LabelData LabelData
order by 2, 1
	

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
	@Shipper int

set	@Shipper = 59613

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = [FT].[usp_LabelPallet_ADAC_by_Shipper]
	@Shipper = @Shipper
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
