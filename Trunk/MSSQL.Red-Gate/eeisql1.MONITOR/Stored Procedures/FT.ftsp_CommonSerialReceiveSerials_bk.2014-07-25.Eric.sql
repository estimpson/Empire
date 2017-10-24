SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_CommonSerialReceiveSerials_bk.2014-07-25.Eric]
	@OriginPlant varchar (20)
,	@Result int = null out
as
/*
begin transaction
declare
	@Result int

execute	@Result = FT.ftsp_CommonSerialReceiveSerials
	@OriginPlant = 'EEH'

select
	@Result

select	*
from	FT.CommonSerialShipLog
where	RowStatus = 200

select	*
from	audit_trail
where	serial in (select Serial from FT.CommonSerialShipLog where RowStatus = 200)



rollback
*/
set nocount on
set ansi_nulls on
set ansi_warnings on

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

/*	Only allow this procedure to be called once at a time by testing for the existance
	of a temproary table which will exist the entire time the procedure is running.
*/
if	exists
		(	select
				*
			from
				tempdb.dbo.sysobjects so
			where
				so.type = 'U'
				and so.name like '#CommonSerialReceiveSerials_OneAtATime%'
		)
	begin
	set	@Result = -1
	RAISERROR ('Procedure already running.  Wait and try %s later.', 16, 1, @ProcName)
	return @Result
end

create table
	#CommonSerialReceiveSerials_OneAtATime
(	OneAtATime bit
)

--	Declarations:
declare	@NowDT datetime
set	@NowDT = GetDate ()

--	I.	Move new records from Ship Log transfer to Ship Log.
declare	@LastShippedID int,
	@LastReceivedID int

set	@LastReceivedID = IsNull (
	(	select	Max (ID)
		from	FT.CommonSerialShipLog
		where	Origin = @OriginPlant), 0) + 1

declare	@TransitSQL nvarchar (1000),
	@ParmDefinition nvarchar (1000),
	@NewRows int

set	@TransitSQL =N'
select	@LastShippedID = ID
from	OpenQuery (' + FT.fn_GetLinkedServer (@OriginPlant) + ', ''
		select	ID = max (ID)
		from	Monitor.FT.CommonSerialShipLog'')
'

set	@ParmDefinition = N'@LastShippedID int output'

execute	@ProcResult = sp_executesql
	@TransitSQL,
	@ParmDefinition,
	@LastShippedID output

set	@Error = @@Error

if	@ProcResult != 0 or @Error != 0 or isnull (@LastShippedID, -1) !> 0 begin
	set @Result = -1
	raiserror ('Unable to check for new serials...', 16, 1)
	return @Result
end

set	@TransitSQL =N'
insert
	FT.CommonSerialShipLog
select
	*
from
	OpenQuery (' + FT.fn_GetLinkedServer (@OriginPlant) + ', ''

		select	*
		from	Monitor.FT.CommonSerialShipLog
		where	Origin = ''''' + @OriginPlant + ''''' and  
				ID between ' + convert (varchar, @LastReceivedID) + ' and ' + convert (varchar, @LastShippedID) + ''')

set	@NewRows = @@RowCount
'

set	@ParmDefinition = N'@InternalOriginPlant varchar(20), @NewRows int output'

execute	@ProcResult = sp_executesql
	@TransitSQL,
	@ParmDefinition,
	@InternalOriginPlant = @OriginPlant,
	@NewRows = @NewRows output

set	@Error = @@Error

if	@ProcResult != 0 or @Error != 0 begin
	set @Result = -1
	raiserror ('Unable to get new serials...', 16, 1)
	return @Result
end
if	isnull (@NewRows, -1) !> 0 begin
	set @Result = 100
	raiserror ('No new serials...', 10, 1)
	--return @Result
end

--		A.	Any records that have already been received , mark as processed.
update
	FT.CommonSerialShipLog
set
	RowStatus = 0 --Processed
where
	Origin = @OriginPlant
	and RowStatus is null
	and	exists --Already received
		(	select
				*
			from
				audit_trail
			where
				FT.CommonSerialShipLog.Serial = serial
				and type = 'R'
		)
	and not exists --Already received but RTVd
		(	select
				*
			from
				audit_trail
			where
				FT.CommonSerialShipLog.Serial = serial
				and type = 'V'
		)

--	II.	Set status to In Process.
update	FT.CommonSerialShipLog
set		RowStatus = 103
where	Origin = @OriginPlant and
		RowStatus is null

--	III.	Perform receiving.
--Commented by Andre 2008-01-28 Now deleting and Inserting permanent table PODetail
/*declare @PODUpdate table
(	PONumber int,
	Part varchar (25),
	DueDT datetime,
	RowId numeric (20,6),
	NewBalance numeric (20,6),
	NewReceived numeric (20,6),
	LastReceivedAmount numeric (20,6),
	LastReceivedDT datetime,
	primary key nonclustered
	(	LastReceivedAmount,
		PONumber,
		Part,
		DueDT,
		RowID))*/
--		A.	Calculate PO Detail balances after receipts.
declare
	@Plant varchar(20)

set	@Plant = FT.fn_VarcharGlobal ('Plant')

truncate table PODetail

insert	PODetail
select	POD.PONumber,
	POD.Part,
	POD.DueDT,
	POD.RowID,
	NewBalance =
	case	when POR.TotQuantity > POD.PostAccum then 0
		when POR.TotQuantity < POD.PostAccum - POD.Balance then POD.Balance
		else POD.PostAccum - POR.TotQuantity
	end,
	NewReceived = POD.Received +
	case	when POR.TotQuantity > POD.PostAccum then POD.Balance
		when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
		else POR.TotQuantity - (POD.PostAccum - POD.Balance)
	end,
	LastReceivedAmount = isnull (
	case	when POR.TotQuantity > POD.PostAccum then POD.Balance
		when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
		else POR.TotQuantity - (POD.PostAccum - POD.Balance)
	end, 0),
	LastReceivedDT = isnull (
	case	when POR.TotQuantity < POD.PostAccum - POD.Balance then null
		else @NowDT
	end, @NowDT)
from	FT.vwCommonSerial_POD POD
	join FT.vwCommonSerial_POReceipts POR on POD.PONumber = POR.PONumber
where	POR.Origin = @OriginPlant 


declare	@TranDT datetime

set	@TranDT= getdate()

insert into PODetail_ReceiptCalculation(PONumber,
	Part,
	DueDT,
	RowID,
	NewBalance,
	NewReceived,
	LastReceivedAmount,
	LastReceivedDT, 
	ProcessDT )
select	PONumber,
	Part,
	DueDT,
	RowID,
	NewBalance,
	NewReceived,
	LastReceivedAmount,
	LastReceivedDT,
	@TranDT
from	PODetail


insert into PODetail_Historical(po_number, part_number, date_due, row_id, last_recvd_date,
		LastReceivedDT, last_recvd_amount, LastReceivedAmount, balance, NewBalance, received, NewReceived,
		ProcessDT )
select	
	po_detail.po_number, po_detail.part_number, po_detail.date_due, po_detail.row_id,
	po_detail.last_recvd_date, POD.LastReceivedDT,
	po_detail.last_recvd_amount ,POD.LastReceivedAmount,
	po_detail.balance, POD.NewBalance,
	po_detail.received , POD.NewReceived, @TranDT
from	po_detail
	join POdetail POD on po_detail.po_number = POD.PONumber and
		po_detail.part_number = POD.Part and
		po_detail.date_due = POD.DueDT and
		po_detail.row_id = POD.RowID
where	POD.LastReceivedAmount > 0

		--and
		--	POR.Destination like @Plant + '%'

--		B.	Update PO Detail with new balance, received, last received amount, and last received date.
--	Now joining on PODetail, not @PODetail Andre 2008-01-28
update	po_detail
set	po_detail.last_recvd_date = POD.LastReceivedDT,
	po_detail.last_recvd_amount = POD.LastReceivedAmount,
	po_detail.balance = POD.NewBalance,
	po_detail.received = POD.NewReceived
from	po_detail
	join POdetail POD on po_detail.po_number = POD.PONumber and
		po_detail.part_number = POD.Part and
		po_detail.date_due = POD.DueDT and
		po_detail.row_id = POD.RowID
where	POD.LastReceivedAmount > 0

--		C.	Create Pallet objects.
declare
	@ShipperContainers table
(	Shipper int
,	ShipDT datetime
,	ContainerNum int
,	ContainerCode varchar(10)
)

insert
	@ShipperContainers
(	Shipper
,	ShipDT
)
select
	ShipLog.Shipper
,	ShipDT = min(ShipLog.ShipDT)
from
    FT.vwCommonSerial_ShipLogInProcess ShipLog
group by
    ShipLog.Shipper

update
	sc
set
	ContainerNum = (select count(distinct PrevShipper.Shipper) from FT.CommonSerialShipLog PrevShipper where PrevShipper.ShipDT between sc.ShipDT - 1 and sc.ShipDT and datediff (day, PrevShipper.ShipDT, sc.ShipDT) = 0)
from
	@ShipperContainers sc

update
	@ShipperContainers
set
	ContainerCode = FT.fn_GetNextContainerLocation (ShipDT, ContainerNum)

insert	object
(	serial, part, location, last_date, operator, status, type)
select	serial = ShipLogInProcess.PalletSerial,
	part = 'PALLET',
	location = min(Container.ContainerCode),
	last_date = min (ShipLogInProcess.ShipDT),
	operator = min (ShipLogInProcess.Origin),
	status = 'A',
	type = 'S'
from	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join
	@ShipperContainers Container on ShipLogInProcess.Shipper = Container.Shipper
where	ShipLogInProcess.Origin = 'EEH' and
	--ShipLogInProcess.Destination like @Plant + '%' and
	ShipLogInProcess.PalletSerial > 0 and
	not exists
	(	select	1
		from	object
		where	ShipLogInProcess.PalletSerial = object.serial)
group by
	ShipLogInProcess.PalletSerial

--		D.	Create Pallet audit trail.
insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, price, operator, from_loc, to_loc, status, object_type)
select	serial = ShipLogInProcess.PalletSerial,
	date_stamp = min (ShipLogInProcess.ShipDT),
	type = 'P',
	part = 'PALLET',
	quantity = 0,
	remarks = 'New Pallet',
	price = 0,
	operator = min (ShipLogInProcess.Origin),
	from_loc = min (ShipLogInProcess.Origin),
	to_loc = min(Container.ContainerCode),
	status = 'A',
	object_type = 'S'
from	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container on ShipLogInProcess.Shipper = Container.Shipper
where	ShipLogInProcess.Origin = @OriginPlant and
	--ShipLogInProcess.Destination like @Plant + '%' and
	ShipLogInProcess.PalletSerial > 0
group by
	ShipLogInProcess.PalletSerial

--		E.	Create inventory objects.
insert	object
(	serial, part, location, last_date, unit_measure, operator, status, origin, cost, parent_serial, quantity, last_time,
	po_number, plant, std_quantity, std_cost, user_defined_status)
select	distinct serial = ShipLogInProcess.Serial,
	part = ShipLogInProcess.Part,
	location = Container.ContainerCode,
	last_date = ShipLogInProcess.ShipDT,
	unit_measure = ShipLogInProcess.RcvdUnit,
	operator = ShipLogInProcess.Origin,
	status = ShipLogInProcess.Status,
	origin = ShipLogInProcess.Origin + '-' + convert (varchar, ShipLogInProcess.Shipper),
	cost = ShipLogInProcess.RcvdCost,
	parent_serial = ShipLogInProcess.PalletSerial,
	quantity = ShipLogInProcess.Quantity,
	last_time = @NowDT,
	po_number = ShipLogInProcess.PONumber,
	plant = ShipLogInProcess.RcvdPlant,
	std_quantity = ShipLogInProcess.Quantity,
	std_cost = ShipLogInProcess.RcvdCost,
	user_defined_status = ShipLogInProcess.UserStatus
from	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container on ShipLogInProcess.Shipper = Container.Shipper
where	ShipLogInProcess.Origin = @OriginPlant and
	--ShipLogInProcess.Destination like @Plant + '%' and
	not exists
	(	select
			*
		from
			dbo.object o
		where
			serial = ShipLogInProcess.Serial)
order by
	ShipLogInProcess.Serial

--		F.	Create inventory audit trail.
insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, price, vendor, po_number, operator, from_loc, to_loc, on_hand, status,
	shipper, unit, std_quantity, cost, plant, gl_account, std_cost, user_defined_status, parent_serial)
select	distinct serial = ShipLogInProcess.Serial,
	date_stamp = ShipLogInProcess.ShipDT,
	type = 'R',
	part = ShipLogInProcess.Part,
	quantity = ShipLogInProcess.Quantity,
	remarks = 'Receiving',
	price = ShipLogInProcess.RcvdPrice,
	vendor = ShipLogInProcess.Origin,
	po_number = ShipLogInProcess.PONumber,
	operator = ShipLogInProcess.Origin,
	from_loc = ShipLogInProcess.Origin,
	to_loc = Container.ContainerCode,
	on_hand =
	(	select	IsNull (min (part_online.on_hand), 0) + sum (SL2.Quantity)
		from	FT.vwCommonSerial_ShipLogInProcess SL2
			left outer join part_online on SL2.Part = part_online.part
		where	SL2.Serial <= ShipLogInProcess.Serial and
			SL2.Part = ShipLogInProcess.Part and
			SL2.Status = 'A'),
	status = ShipLogInProcess.Status,
	shipper = ShipLogInProcess.Origin + '-' + convert (varchar, ShipLogInProcess.Shipper),
	unit = ShipLogInProcess.RcvdUnit,
	std_quantity = ShipLogInProcess.Quantity,
	cost = ShipLogInProcess.RcvdCost,
	plant = ShipLogInProcess.RcvdPlant,
	gl_account = '?',
	std_cost = ShipLogInProcess.RcvdCost,
	user_defined_status = ShipLogInProcess.UserStatus,
	parent_serial = ShipLogInProcess.PalletSerial
from	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container on ShipLogInProcess.Shipper = Container.Shipper
where	ShipLogInProcess.Origin = @OriginPlant and
	--ShipLogInProcess.Destination like @Plant + '%' and
	not exists
	(	select
			*
		from
			dbo.audit_trail at
		where
			type = 'R'
			and serial = ShipLogInProcess.Serial and at.serial not in ( select serial from audit_trail at4 where type = 'V' and at4.serial = ShipLoginProcess.Serial))
order by
	ShipLogInProcess.Serial

--		G.	Recalculate part online.
update	part_online
set	part_online.on_hand = POH.OnHand
from	part_online
	join FT.vwPOH POH on part_online.part = POH.Part
where	part_online.part in
	(	select	Part
		from		PODetail
		where	LastReceivedAmount > 0)

--	IV.	Mark records as processed and ready to retransmit.
update	FT.CommonSerialShipLog
set	RowStatus = 0,
	ReceiveDT = @NowDT,
	PONumber = ShipLogInProcess.PONumber,
	RcvdUnit = ShipLogInProcess.RcvdUnit,
	RcvdPrice = ShipLogInProcess.RcvdPrice,
	RcvdCost = ShipLogInProcess.RcvdCost,
	RcvdWeight = ShipLogInProcess.RcvdWeight,
	RcvdTareWeight = ShipLogInProcess.RcvdTareWeight
from	FT.CommonSerialShipLog CommonSerialShipLog
	join FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess on CommonSerialShipLog.Serial = ShipLogInProcess.Serial
where	ShipLogInProcess.Origin = @OriginPlant 
	--and ShipLogInProcess.Destination like @Plant + '%'

GO
