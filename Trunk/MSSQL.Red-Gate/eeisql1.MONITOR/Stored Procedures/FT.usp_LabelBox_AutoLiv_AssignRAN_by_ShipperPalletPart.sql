SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [FT].[usp_LabelBox_AutoLiv_AssignRAN_by_ShipperPalletPart]
	@Shipper int
, @PalletSerial int
, @PalletPart varchar(25)
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>
/*	Object serial must be staged to a shipper. */
if	not exists
	(	select
			*
		from
			dbo.object o
		where
			coalesce(shipper,0) = @Shipper
		
	) begin
	
	set	@Result = 999999
	RAISERROR ('Error assigning RAN to serial %d.  This serials must be staged to a shipper.', 16, 1, @Shipper)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
/*	Clear RANs from custom1 for all objects on this shipper --User is relabeling for entire shipper */

Update
	object
Set
	custom1 = ''
where
	object.shipper =  @Shipper

	Update
	object
Set
	custom5 = ''
where
	object.shipper =  @Shipper

/*	Get all open releases for the order related to this shipper line. */
declare
	@openReleases table
(	ID int not null IDENTITY(1, 1) primary key
,	CustomerPart varchar(25)
,	CustomerPO varchar(50)
,	Destination varchar(50)
,	PartCode varchar(25)
,	StdQty numeric(20,6)
,	ReleaseNo varchar(30)
,	ShipWindow VARCHAR(30)
,	PriorOrderAccum numeric(20,6)
,	PostOrderAccum numeric(20,6)
,	NetPriorAccumRequired numeric(20,6) default 0
,	NetPostAccumRequired numeric(20,6)default 0
,	LabelledQty numeric(20,6)
)

insert
	@openReleases
(	CustomerPart
,	CustomerPO
,	Destination
,	PartCode
,	StdQty
,	ReleaseNo
,	ShipWindow
)
select
	CustomerPart = od.customer_part
,	CustomerPO = oh.customer_po
,	destination = oh.destination
,	PartCode = od.part_number
,	StdQty = od.std_qty
,	ReleaseNo = od.release_no
,	ShipWindow = od.custom01

from
	dbo.shipper_detail sd
	join dbo.shipper s
		on s.id = sd.shipper
	join dbo.order_header oh 
		on oh.customer_part = sd.customer_part
		and oh.destination = s.destination
		and	oh.customer_po = sd.customer_po
	join dbo.order_detail od
		on od.order_no = oh.order_no
where
	sd.shipper = @Shipper
	and datalength(od.release_no)>= 11
order by
		
		sd.customer_part
	,	sd.customer_po
	,	od.due_date
	,	od.custom01
	,	od.release_no
	,   od.id

/*	Get all inventory staged for customer_part, customer_po, destination for shipper.*/
declare
	@stagedInventory table
(	ID int not null IDENTITY(1, 1) primary key
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	Destination varchar(25)
,	ReleaseNo varchar(30)
,	ShipWindow VARCHAR(30)
,	SerialNo int
,	ShipperID int
,	StdQty numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
)

insert
	@stagedInventory
(	CustomerPart
,	CustomerPO
,	Destination	
,	ReleaseNo
,	ShipWindow
,	SerialNo
,	ShipperID
,	StdQty
)
select
    CustomerPart = sd.customer_part
,   CustomerPO = sd.customer_po
,   destination = sStaged.destination
,   ReleaseNo = coalesce(o.custom1, '')
,	ShipWindow = coalesce(o.custom5, '')
,   SerialNo = o.serial
,   ShipperID = o.shipper
,   StdQty = o.std_quantity
from
    dbo.object o
    join shipper_detail sd
        on sd.shipper = o.shipper
           and sd.part_original = o.part
    join shipper sStaged
        on sStaged.id = sd.shipper
           --and sStaged.status = 'S'
where
    exists
	(	select
			*
        from
			shipper_detail sd2
        where
			sd2.customer_po = sd.customer_po
			and sd2.customer_part = sd.customer_part
			and sd2.shipper = @Shipper
	)
order by
    o.shipper
,   o.parent_serial
,   sd.customer_part
,   sd.customer_po
,   coalesce(o.custom5, '')
,   coalesce(o.custom1, '')

update
	si
set	PriorAccum = coalesce
	(	(	select
				sum(si1.StdQty)
			from
				@stagedInventory si1
			where
				si1.ID < si.ID and
				si1.CustomerPart = si.CustomerPart and
				si1.CustomerPO = si.CustomerPO
		)
	,	0
	)
,	PostAccum = coalesce
	(	(	select
				sum(si1.StdQty)
			from
				@stagedInventory si1
			where
				si1.ID <= si.ID and
				si1.CustomerPart = si.CustomerPart and
				si1.CustomerPO = si.CustomerPO
		)
	,	0
	)
from
	@stagedInventory si

/*	Calculate the first release with unmet labelled inventory...*/
/*		First, calculate the prior/post accum for open releases.*/
update
	[or]
set	PriorOrderAccum = coalesce
	(	(	select
				sum(or1.StdQty)
			from
				@openReleases or1
			where
				or1.ID < [or].ID and
				or1.CustomerPart = [or].CustomerPart and
				or1.CustomerPO = [or].CustomerPO
				
		)
	,	0
	)
,	PostOrderAccum = coalesce
	(	(	select
				sum(or1.StdQty)
			from
				@openReleases or1
			where
				or1.ID <= [or].ID and
				or1.CustomerPart = [or].CustomerPart and
				or1.CustomerPO = [or].CustomerPO
		)
	,	0
	)
from
	@openReleases [or]



/*		Apply inventory already labelled for this shipment.*/
update
	[or]
set LabelledQty = coalesce(si.StdQty, 0)
from
	@openReleases [or]
	left join @stagedInventory si
		on	si.ReleaseNo = [or].ReleaseNo and
			si.CustomerPO = [or].CustomerPO AND
			si.CustomerPart = [or].CustomerPart AND
			DATALENGTH(si.ReleaseNo) >= 11

/*Net Prior and Post Accums based on already labeled inventory*/
UPDATE
	[or]
SET NetPriorAccumRequired = PriorOrderAccum-LabelledQty,
	NetPostAccumRequired = PostOrderAccum-LabelledQty
FROM
	@openReleases [or]
	
UPDATE
	[si]
SET ShipWindow = ( SELECT MIN([or].ShipWindow)
					FROM
						@openReleases [or]
					WHERE
						[or].CustomerPart = [si].CustomerPart AND
						[or].CustomerPO = [si].CustomerPO AND
						[si].PostAccum > [or].NetPriorAccumRequired AND
						[si].PostAccum <= [or].NetPostAccumRequired
						
						)
FROM
	@StagedInventory [si]
WHERE
	[si].ReleaseNo = '' 
	AND [si].ShipperID = @Shipper


UPDATE
	[si]
SET ReleaseNo = ( SELECT MIN([or].ReleaseNo)
					FROM
						@openReleases [or]
					WHERE
						[or].CustomerPart = [si].CustomerPart AND
						[or].CustomerPO = [si].CustomerPO AND
						[si].PostAccum > [or].NetPriorAccumRequired AND
						[si].PostAccum <= [or].NetPostAccumRequired
						
						)
FROM
	@StagedInventory [si]
WHERE
	[si].ReleaseNo = '' 
	AND [si].ShipperID = @Shipper

/*	Update object.*/
--- <Update rows="1">
SET	@TableName = 'dbo.object'

UPDATE
	o
SET
	custom1 = [si].ReleaseNo
FROM
	dbo.object o
JOIN
	@stagedInventory [si] ON 
	[si].SerialNo = o.serial
WHERE
	o.shipper = @Shipper


UPDATE
	o
SET
	custom5 = [si].ShipWindow
FROM
	dbo.object o
JOIN
	@stagedInventory [si] ON 
	[si].SerialNo = o.serial
WHERE
	o.shipper = @Shipper

SELECT
	@Error = @@Error,
	@RowCount = @@Rowcount

IF	@Error != 0 BEGIN
	SET	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	ROLLBACK TRAN @ProcName
	RETURN
END
IF	@RowCount = 0 BEGIN
	SET	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	ROLLBACK TRAN @ProcName
	RETURN
END



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
    o.shipper = @Shipper AND
		o.part = @PalletPart AND
		o.parent_serial = @PalletSerial

SELECT
    LabelData.CustomerPart
,   LabelData.ObjectSerial
,   LabelData.ObjectParentSerial
,   LabelData.PartName
,   LabelData.Quantity
,   LabelData.RAN
,   LabelData.SupplierCode
,   LabelData.RevLevel
,   LabelData.DockCode
,   LabelData.LineFeedCode
,   LabelData.ShipWindow
,   LabelData.MfgDate
,   LabelData.ShipTo
,   LabelData.CompanyName
,   LabelData.CompanyAdd1
,   LabelData.CompanyAdd2
,   LabelData.CompanyAdd3
FROM
    @LabelData LabelData
ORDER BY
    LabelData.ObjectParentSerial
 ,	LabelData.ShipWindow
,   LabelData.CustomerPart
,   LabelData.RAN
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
	@Shipper int

set	@Shipper = 59613

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = ft.usp_LabelBox_AutoLiv_AssignRAN_by_ShipperPalletPart
	@Shipper = @Shipper
, @PalletSerial = @PalletSerial
, @PalletPart = @PalletPart
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
