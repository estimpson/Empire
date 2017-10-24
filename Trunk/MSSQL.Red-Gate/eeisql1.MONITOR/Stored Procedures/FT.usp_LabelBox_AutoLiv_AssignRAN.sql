SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[usp_LabelBox_AutoLiv_AssignRAN]
	@serial int
,	@tranDT datetime = null out
,	@result integer = null out
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
			serial = @serial
			and o.shipper > 0
	) begin
	
	set	@Result = 999999
	RAISERROR ('Error assigning RAN to serial %d.  This serial must be staged to a shipper.', 16, 1, @serial)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
declare
	@shipperID int
,	@partCode varchar(25)

select
	@shipperID = o.shipper
,	@partCode = o.part
from
	dbo.object o
where
	serial = @serial

/*	Get all open releases for the order related to this shipper line. */

declare
	@openReleases table
(	ID int not null IDENTITY(1, 1) primary key
,	OrderNo int
,	PartCode varchar(25)
,	StdQty numeric(20,6)
,	ReleaseNo varchar(30)
,	ShipWindow VARCHAR(30)
,	PriorOrderAccum numeric(20,6)
,	PostOrderAccum numeric(20,6)
,	PriorShipperAccum numeric(20,6)
,	PostShipperAccum numeric(20,6)
,	PriorNettedAccum numeric(20,6)
,	PostNettedAccum numeric(20,6)
,	NetQtyRequired numeric(20,6)
,	LabelledQty numeric(20,6)
)

insert
	@openReleases
(	OrderNo
,	PartCode
,	StdQty
,	ReleaseNo
,	ShipWindow
)
select
	OrderNo = od.order_no
,	PartCode = od.part_number
,	StdQty = od.std_qty
,	ReleaseNo = od.release_no
,	ShipWindow = COALESCE(od.custom01,'')
FROM
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
	sd.shipper = @shipperID
	and sd.part_original = @partCode
	and datalength(od.release_no)>= 11
order by
		
		sd.customer_part
	,	sd.customer_po
	,	od.due_date
	,	od.release_no
	,   od.id

/*	Get all open shippers (in ship date/time order) for these releases. */
declare
	@openShippers table
(	ID int not null IDENTITY(1, 1) primary key
,	ShipperID int
,	StdQty numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
)

insert
	@openShippers
(	ShipperID
,	StdQty
)
select
	ShipperID = sd.shipper
,	StdQty = sd.qty_required
from
	dbo.shipper_detail sd
	join dbo.shipper sOpen
		on sOpen.id = sd.shipper
		and sOpen.status in ('O', 'A', 'S')
where
	sd.order_no = (select max(OrderNo) from @openReleases)
order by
	sOpen.date_stamp
,	sd.shipper

update
	os
set	PriorAccum = coalesce
	(	(	select
				sum(os1.StdQty)
			from
				@openShippers os1
			where
				os1.ID < os.ID
		)
	,	0
	)
,	PostAccum = coalesce
	(	(	select
				sum(os1.StdQty)
			from
				@openShippers os1
			where
				os1.ID <= os.ID
		)
	,	0
	)
from
	@openShippers os

/*	Get all inventory staged to this shipper grouped by release.*/
declare
	@stagedInventory table
(	ID int not null IDENTITY(1, 1) primary key
,	ReleaseNo varchar(30)
,	ShipWindow VARCHAR(30)
,	StdQty numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
)

insert
	@stagedInventory
(	ReleaseNo
,	ShipWindow
,	StdQty
)
select
	ReleaseNo =
		case
			when	o.serial = @serial then null
			else			nullif(o.custom1,'') 
		END
    ,ShipWindow =
		case
			when	o.serial = @serial then null
			else			nullif(o.custom5,'') 
		end
,	StdQty = sum(o.std_quantity)
from
	dbo.object o
where
	o.shipper = @shipperID
	and o.part = @partCode
group by
		case
			when	o.serial = @serial then null
			else			nullif(o.custom1,'') 
		END
        , case
			when	o.serial = @serial then null
			else			nullif(o.custom5,'') 
		end

update
	si
set	PriorAccum = coalesce
	(	(	select
				sum(si1.StdQty)
			from
				@stagedInventory si1
			where
				si1.ID < si.ID
		)
	,	0
	)
,	PostAccum = coalesce
	(	(	select
				sum(si1.StdQty)
			from
				@stagedInventory si1
			where
				si1.ID <= si.ID
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
				or1.ID < [or].ID
		)
	,	0
	)
,	PostOrderAccum = coalesce
	(	(	select
				sum(or1.StdQty)
			from
				@openReleases or1
			where
				or1.ID <= [or].ID
		)
	,	0
	)
from
	@openReleases [or]

/*		Get the prior/post accum for this shipment based on ship date/time order.*/
update
	[or]
set	PriorShipperAccum = os.PriorAccum
,	PostShipperAccum = os.PostAccum
from
	@openReleases [or]
	join @openShippers os
		on os.ShipperID = @shipperID

/*		Net shipment accums against release accums to determine releases that belong to this shipment.*/
update
	[or]
set	PriorNettedAccum =
		case
			when [or].PriorOrderAccum > [or].PriorShipperAccum then [or].PriorOrderAccum
			else [or].PriorShipperAccum
		end
,	PostNettedAccum =
		case
			when [or].PostOrderAccum < [or].PostShipperAccum then [or].PostOrderAccum
			else [or].PostShipperAccum
		end
from
	@openReleases [or]

/*		Calculate acutal net release requirements for this shipment.*/
update
	[or]
set NetQtyRequired =
		case
			when [or].PostNettedAccum > [or].PriorNettedAccum then [or].PostNettedAccum - [or].PriorNettedAccum
			else 0
		end
from
	@openReleases [or]

/*		Apply inventory already labelled for this shipment.*/
update
	[or]
SET LabelledQty = COALESCE(si.StdQty, 0)
FROM
	@openReleases [or]
	LEFT JOIN @stagedInventory si
		ON si.ReleaseNo = [or].ReleaseNo

/*	Get the RAN information for the first release with unmet labelled inventory.*/
DECLARE
	 @SalesOrderNo INT
	,@RANNumber VARCHAR(25)
	,@ShipWindow VARCHAR(25)

SELECT
	@SalesOrderNo = [or].OrderNo
,	@RANNumber = [or].ReleaseNo
,	@ShipWindow = [or].ShipWindow
FROM
	@openReleases [or]
WHERE
	[or].ID =
		(	SELECT
				MIN(ID)
			FROM
				@openReleases or1
			WHERE
				or1.NetQtyRequired > or1.LabelledQty
		)

IF	@RANNumber IS NULL BEGIN
	
	SET	@Result = 999999
	RAISERROR ('Error finding RAN for serial %d.  Unable to find an open release.', 16, 1, @serial)
	ROLLBACK TRAN @ProcName
	RETURN
END

/*	Assign RAN to object if not already assigned.*/
IF	NOT EXISTS
	(	SELECT
			*
		FROM
			dbo.object o
		WHERE
			serial = @serial
			AND custom1 = @RANNumber
	) BEGIN
	
	--/*	Add object quantity back to previously assigned order KANBAN.*/
	----- <Update rows="*">
	--set	@TableName = 'dbo.kanban'
	
	--update
	--	k
	--set
	--	standard_quantity = k.standard_quantity + o.std_quantity
	--from
	--	dbo.kanban k
	--	join dbo.object o
	--		on o.serial = @serial
	--where
	--	k.order_no = @SalesOrderNo
	--	and k.kanban_number = o.kanban_number
	--	and k.line16 = o.custom4
	--	and k.line17 = o.custom5
	
	--select
	--	@Error = @@Error,
	--	@RowCount = @@Rowcount
	
	--if	@Error != 0 begin
	--	set	@Result = 999999
	--	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	--	rollback tran @ProcName
	--	return
	--end
	----- </Update>
	
	/*	Update object.*/
	--- <Update rows="1">
	SET	@TableName = 'dbo.object'

	UPDATE
		o
	SET
		custom1 = @RANNumber
	FROM
		dbo.object o
	WHERE
		serial = @serial

	UPDATE
		o
	SET
		custom5 = @ShipWindow
	FROM
		dbo.object o
	WHERE
		serial = @serial

	SELECT
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		SET	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		ROLLBACK TRAN @ProcName
		RETURN
	END
	IF	@RowCount != 1 BEGIN
		SET	@Result = 999999
		RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		ROLLBACK TRAN @ProcName
		RETURN
	END
	--- </Update>
	
	--/*	Deduct object quantity from order KANBAN.*/
	----- <Update rows="*">
	--set	@TableName = 'dbo.kanban'
	
	--update
	--	k
	--set
	--	standard_quantity = k.standard_quantity - o.std_quantity
	--from
	--	dbo.kanban k
	--	join dbo.object o
	--		on o.serial = @serial
	--where
	--	k.order_no = @SalesOrderNo
	--	and k.kanban_number = @AAKANBAN
	--	and k.line16 = @AARelease
	--	and k.line17 = @AAOrderID
	
	--select
	--	@Error = @@Error,
	--	@RowCount = @@Rowcount
	
	--if	@Error != 0 begin
	--	set	@Result = 999999
	--	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	--	rollback tran @ProcName
	--	return
	--end
	--- </Update>

END

	--Get Data for Label

	DECLARE @MfgDate DATETIME
	SELECT 
		@MfgDate = COALESCE((SELECT MIN(MfgDT) FROM FT.CommonSerialShipLog WHERE serial = @serial), DATEADD(dd,-30, GETDATE()))

	SELECT 
		sd.customer_part AS CustomerPart,
		o.serial AS ObjectSerial,
		p.name AS PartName,
		o.quantity AS Quantity,
		o.custom1 AS RAN,
		es.supplier_code AS SupplierCode,
		oh.engineering_level AS RevLevel,
		oh.dock_code AS DockCode,
		oh.line_feed_code AS LineFeedCode,
		COALESCE(o.custom5,'') AS ShipWindow, --Still need to write this to object from order_detail
		@MfgDate AS MfgDate,
		RIGHT(COALESCE(NULLIF(es.EDIShipToID,''),NULLIF(es.parent_destination,''), es.destination ),3) AS ShipTo,
		parms.company_name AS CompnyName,
		parms.address_1 AS CompnyAdd1,
		parms.address_2 AS CompnyAdd2,
		parms.address_3 AS CompnyAdd3
				
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
CROSS JOIN parameters parms
		WHERE 
				o.serial = @serial

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
	@serial int

set	@serial = 1302688

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_AmericanAxle_AssignKANBAN
	@serial = @serial
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.object
where
	serial = @serial
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
