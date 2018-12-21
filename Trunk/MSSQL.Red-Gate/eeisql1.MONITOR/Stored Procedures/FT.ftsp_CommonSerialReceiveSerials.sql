SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_CommonSerialReceiveSerials]
	@OriginPlant varchar (20)
,	@TranDT datetime = null out
,	@Result integer = null out
/*



Exec	[FT].[ftsp_CommonSerialReceiveSerials]
		@OriginPlant = 'EEH'

*/

as
set nocount on
set ansi_warnings on
set ansi_nulls on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
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

---	</ArgumentValidation>

--- <Body>
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
	rollback tran @ProcName
	return @Result
end

create table
	tempdb..CommonSerialReceiveSerials_OneAtATime
(	OneAtATime bit
)

/*	Move new records from Ship Log transfer to Ship Log. */
declare
	@LastShippedID int
,	@LastReceivedID int

set @LastReceivedID = coalesce
	(	(	select
				max(ID)
			from
				FT.CommonSerialShipLog
			where
				Origin = @OriginPlant
		)
	,	0
	) + 1

declare
	@TransitSQL nvarchar(max)
,	@ParmDefinition nvarchar(max)
,	@NewRows int

set	@TransitSQL =N'
select	@LastShippedID = ID
from	OpenQuery (' + FT.fn_GetLinkedServer (@OriginPlant) + ', ''
		select	ID = max (ID)
		from	EEH.FT.CommonSerialShipLog'')
'

set	@ParmDefinition = N'@LastShippedID int output'

--- <Call>	
set	@CallProcName = 'sp_executesql'
execute
	@ProcReturn = sp_executesql
			@TransitSQL
		,	@ParmDefinition
		,	@LastShippedID output

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	coalesce (@LastShippedID, -1) !> 0 begin
	set @Result = -1
	raiserror ('Unable to check for new serials...', 16, 1)
	rollback tran @ProcName
	return @Result
end

--- </Call>

set	@TransitSQL =N'
insert
	FT.CommonSerialShipLog
select
	*
from
	OpenQuery (' + FT.fn_GetLinkedServer (@OriginPlant) + ', ''

		select
			*
		from
			EEH.FT.CommonSerialShipLog
		where
			Origin = ''''' + @OriginPlant + '''''
			and ID between ' + convert (varchar, @LastReceivedID) + ' and ' + convert (varchar, @LastShippedID) + ''')

set	@NewRows = @@RowCount
'

set	@ParmDefinition = N'@InternalOriginPlant varchar(20), @NewRows int output'

--- <Call>	
set	@CallProcName = 'sp_executesql'
execute
	@ProcReturn = sp_executesql
			@TransitSQL
		,	@ParmDefinition
		,	@InternalOriginPlant = @OriginPlant
		,	@NewRows = @NewRows output

set	@Error = @@Error

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	coalesce (@NewRows, -1) !> 0 begin
	set @Result = 100
	raiserror ('No new serials...', 10, 1)
	rollback tran @ProcName
	return @Result
end
--- </Call>

/*	Any records that have already been received but with no RTV after last receipt , mark as processed. */
if	exists

		(
			select
				1
			from
				FT.CommonSerialShipLog cssl
			where
				cssl.Origin = @OriginPlant
				and cssl.RowStatus is null
				and exists
					( Select 1
						from 
							audit_trail at
						where 
							at.serial = cssl.Serial
						and	FT.Fn_CheckSerialForCommonSerialReceipt (at.serial)	= 0)		
			)

--     Commented this section 06/04/2016 ASB FT, LLC
		--(	select
		--		*
		--	from
		--		FT.CommonSerialShipLog cssl
		--	where
		--		cssl.Origin = @OriginPlant
		--		and cssl.RowStatus is null
		--		and	exists --Already received
		--			(	select
		--					*
		--				from
		--					audit_trail atR
		--				where
		--					cssl.Serial = atR.serial
		--					and atR.type = 'R'
		--					and not exists --Already received but RTVd
		--						(	select
		--								*
		--							from
		--								audit_trail atV
		--							where
		--								cssl.Serial = atV.serial
		--								and atV.type = 'V'
		--								and atV.date_stamp > atR.date_stamp
		--						)
		--			)
		--) 
		begin

	--- <Update rows="1+">
	set	@TableName = 'FT.CommonSerialShipLog'

	update
		cssl
	set
		RowStatus = 0 --Processed
	from
		FT.CommonSerialShipLog cssl
	where
		cssl.Origin = @OriginPlant
		and cssl.RowStatus is null
		and	exists --Already received but no RTV after last receipt
			( Select 1
						from 
							audit_trail at
						where 
							at.serial = cssl.Serial
						and	FT.Fn_CheckSerialForCommonSerialReceipt (at.serial)	= 0)	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount <= 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end

/*	Set status to In Process. */
--- <Update rows="1+">
set	@TableName = 'FT.CommonSerialShipLog'

update
	cssl
set
	RowStatus = 103
from
	FT.CommonSerialShipLog cssl
where
	Origin = @OriginPlant
	and RowStatus is null

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--if	@RowCount <= 0 begin
--	set	@Result = 999999
--	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
--	rollback tran @ProcName
--	return
--end
--- </Update>

/*	Calculate PO Detail balances after receipts. */
--- <Insert rows="*">
set	@TableName = 'dbo.PODetail'

truncate table
	dbo.PODetail

--select
--	POD.PONumber
--,	POD.Part
--,	POD.DueDT
--,	POD.RowID
--,	NewBalance =
--		case
--			when POR.TotQuantity > POD.PostAccum then 0
--			when POR.TotQuantity < POD.PostAccum - POD.Balance then POD.Balance
--			else POD.PostAccum - POR.TotQuantity
--		end
--,	NewReceived = POD.Received +
--		case
--			when POR.TotQuantity > POD.PostAccum then POD.Balance
--			when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
--			else POR.TotQuantity - (POD.PostAccum - POD.Balance)
--		end
--,	LastReceivedAmount = coalesce
--		(	case
--				when POR.TotQuantity > POD.PostAccum then POD.Balance
--				when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
--				else POR.TotQuantity - (POD.PostAccum - POD.Balance)
--			end
--		,	0
--		)
--,	LastReceivedDT = coalesce
--		(	case
--				when POR.TotQuantity < POD.PostAccum - POD.Balance then null
--				else @TranDT
--			end
--		,	@TranDT
--		)
--from
--	FT.vwCommonSerial_POD POD
--	join FT.vwCommonSerial_POReceipts POR
--		on POD.PONumber = POR.PONumber
--where
--	POR.Origin = @OriginPlant 



insert
	dbo.PODetail
select  distinct
	POD.PONumber
,	POD.Part
,	POD.DueDT
,	POD.RowID
,	NewBalance =
		case
			when POR.TotQuantity > POD.PostAccum then 0
			when POR.TotQuantity < POD.PostAccum - POD.Balance then POD.Balance
			else POD.PostAccum - POR.TotQuantity
		end
,	NewReceived = POD.Received +
		case
			when POR.TotQuantity > POD.PostAccum then POD.Balance
			when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
			else POR.TotQuantity - (POD.PostAccum - POD.Balance)
		end
,	LastReceivedAmount = coalesce
		(	case
				when POR.TotQuantity > POD.PostAccum then POD.Balance
				when POR.TotQuantity < POD.PostAccum - POD.Balance then 0
				else POR.TotQuantity - (POD.PostAccum - POD.Balance)
			end
		,	0
		)
,	LastReceivedDT = coalesce
		(	case
				when POR.TotQuantity < POD.PostAccum - POD.Balance then null
				else @TranDT
			end
		,	@TranDT
		)
from
	FT.vwCommonSerial_POD POD
	join FT.vwCommonSerial_POReceipts POR
		on POD.PONumber = POR.PONumber
where
	POR.Origin = @OriginPlant 

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Record PO Detail at this moment. */
--- <Insert rows="*">
set	@TableName = 'dbo.PODetail_ReceiptCalculation'

insert
	dbo.PODetail_ReceiptCalculation
(	PONumber
,	Part
,	DueDT
,	RowID
,	NewBalance
,	NewReceived
,	LastReceivedAmount
,	LastReceivedDT
,	ProcessDT
)
select
	PONumber
,	Part
,	DueDT
,	RowID
,	NewBalance
,	NewReceived
,	LastReceivedAmount
,	LastReceivedDT
,	@TranDT
from
	dbo.PODetail pd

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Record PO detail history. */
--- <Insert rows="*">
set	@TableName = 'dbo.PODetail_Historical'

insert
	dbo.PODetail_Historical
(	po_number
,	part_number
,	date_due
,	row_id
,	last_recvd_date
,	LastReceivedDT
,	last_recvd_amount
,	LastReceivedAmount
,	balance
,	NewBalance
,	received
,	NewReceived
,	ProcessDT
)
select
	pd.po_number
,	pd.part_number
,	pd.date_due
,	pd.row_id
,	pd.last_recvd_date
,	pd2.LastReceivedDT
,	pd.last_recvd_amount
,	pd2.LastReceivedAmount
,	pd.balance
,	pd2.NewBalance
,	pd.received
,	pd2.NewReceived
,	@TranDT
from
	dbo.po_detail pd
	join POdetail pd2
		on pd.po_number = pd2.PONumber
			and pd.part_number = pd2.Part
			and pd.date_due = pd2.DueDT
			and pd.row_id = pd2.RowID
where
	pd2.LastReceivedAmount > 0

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Update PO Detail with new balance, received, last received amount, and last received date. */
--- <Update rows="*">
set	@TableName = 'dbo.po_detail pd'

update
	pd
set
	last_recvd_date = pd2.LastReceivedDT
,	last_recvd_amount = pd2.LastReceivedAmount
,	balance = pd2.NewBalance
,	received = pd2.NewReceived
from
	dbo.po_detail pd
	join dbo.PODetail pd2
		on pd.po_number = pd2.PONumber
		   and pd.part_number = pd2.Part
		   and pd.date_due = pd2.DueDT
		   and pd.row_id = pd2.RowID
where
	pd2.LastReceivedAmount > 0

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Get container code(s) for each shipper. */
declare
	@ShipperContainers table
(	Shipper int primary key
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
	ContainerNum =
		(	select
				count(distinct PrevShipper.Shipper)
			from
				FT.CommonSerialShipLog PrevShipper
			where
				PrevShipper.ShipDT between sc.ShipDT - 1 and sc.ShipDT
				and datediff(day, PrevShipper.ShipDT, sc.ShipDT) = 0
		)
from
	@ShipperContainers sc

update
	@ShipperContainers
set
	ContainerCode = FT.fn_GetNextContainerLocation (ShipDT, ContainerNum)

/*	Create pallet(s). */
--- <Insert rows="*">
set	@TableName = 'dbo.object'

insert
	dbo.object
(	serial
,	part
,	location
,	last_date
,	operator
,	status
,	type
)
select
	serial = ShipLogInProcess.PalletSerial
,	part = 'PALLET'
,	location = min(coalesce( ShipperLocation, Container.ContainerCode))
,	last_date = min(ShipLogInProcess.ShipDT)
,	operator = min(ShipLogInProcess.Origin)
,	status = 'A'
,	type = 'S'	
from
	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container
		on ShipLogInProcess.Shipper = Container.Shipper
where
	ShipLogInProcess.Origin = @OriginPlant
	and	ShipLogInProcess.PalletSerial > 0
	and not exists
		(	select
				*
			from
				dbo.object o
			where
				o.serial = ShipLogInProcess.PalletSerial
		)
group by
	ShipLogInProcess.PalletSerial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

--- <Insert rows="*">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	operator
,	from_loc
,	to_loc
,	status
,	object_type
)
select
	serial = ShipLogInProcess.PalletSerial
,	date_stamp = min(ShipLogInProcess.ShipDT)
,	type = 'P'
,	part = 'PALLET'
,	quantity = 0
,	remarks = 'New Pallet'
,	price = 0
,	operator = min(ShipLogInProcess.Origin)
,	from_loc = min(ShipLogInProcess.Origin)
,	to_loc = min(coalesce( ShipperLocation, Container.ContainerCode))
,	status = 'A'
,	object_type = 'S'
from
	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container
		on ShipLogInProcess.Shipper = Container.Shipper
where
	ShipLogInProcess.Origin = @OriginPlant
	and	ShipLogInProcess.PalletSerial > 0
group by
	ShipLogInProcess.PalletSerial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*  Create the location */
set	@TableName = 'dbo.location'
insert into location( Code, Name, type, group_no, plant )
select	Distinct  Code = coalesce( ShipperLocation, Container.ContainerCode),
		Name = coalesce( ShipperLocation, Container.ContainerCode),
		type = 'ST', group_no = 'FINISHED GOODS',
		plant = 'TRAN-EEI'
from
    FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
    join @ShipperContainers Container
        on ShipLogInProcess.Shipper = Container.Shipper
	left join location on Location.code = coalesce( ShipperLocation, Container.ContainerCode)
where
    ShipLogInProcess.Origin = @OriginPlant
    and not exists
		(	select
				1
			from
				dbo.object o
			where
				o.serial = ShipLogInProcess.Serial
		)
	and Location.code is null

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
/*	Create inventory. */
--- <Insert rows="*">
set	@TableName = 'dbo.object'

insert
	dbo.object
(	serial
,	part
,	location
,	last_date
,	unit_measure
,	operator
,	status
,	origin
,	cost
,	parent_serial
,	quantity
,	last_time
,	po_number
,	plant
,	std_quantity
,	std_cost
,	user_defined_status
,	field1
,	Custom1
,	Custom2
,	lot
,	note
)
select
    serial = ShipLogInProcess.Serial
,   part = ShipLogInProcess.Part
,   location = coalesce( ShipperLocation, Container.ContainerCode)
,   last_date = ShipLogInProcess.ShipDT
,   unit_measure = ShipLogInProcess.RcvdUnit
,   operator = ShipLogInProcess.Origin
,   status = ShipLogInProcess.Status
,   origin = ShipLogInProcess.Origin + '-' + convert (varchar, ShipLogInProcess.Shipper)
,   cost = ShipLogInProcess.RcvdCost
,   parent_serial = ShipLogInProcess.PalletSerial
,   quantity = ShipLogInProcess.Quantity
,   last_time = @TranDT
,   po_number = ShipLogInProcess.PONumber
,   plant = ShipLogInProcess.RcvdPlant
,   std_quantity = ShipLogInProcess.Quantity
,   std_cost = ShipLogInProcess.RcvdCost
,   user_defined_status = ShipLogInProcess.UserStatus
,	field1 = ShipLogInProcess.field1
,	custom1 = ShipLogInProcess.AETCNumber
,	custom2 = ShipLogInProcess.BOL
,	lot = ShipLogInProcess.lot
,	note=case when ShipLogInProcess.Status='H' then 'Certified to release ' + ShipLogInProcess.SSR_ID else '' end
from
    FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
    join @ShipperContainers Container
        on ShipLogInProcess.Shipper = Container.Shipper
where
    ShipLogInProcess.Origin = @OriginPlant
    and not exists
		(	select
				*
			from
				dbo.object o
			where
				o.serial = ShipLogInProcess.Serial
		)
order by
    ShipLogInProcess.Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

--- <Insert rows="*">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	status
,	shipper
,	unit
,	std_quantity
,	cost
,	plant
,	gl_account
,	std_cost
,	user_defined_status
,	parent_serial
,	field1
,	Custom1
,	Custom2
,	lot
,	notes 
)
select
	serial = ShipLogInProcess.Serial
,   date_stamp = ShipLogInProcess.ShipDT
,   type = 'R'
,   part = ShipLogInProcess.Part
,   quantity = ShipLogInProcess.Quantity
,   remarks = 'Receiving'
,   price = ShipLogInProcess.RcvdPrice
,   vendor = ShipLogInProcess.Origin
,   po_number = ShipLogInProcess.PONumber
,   operator = ShipLogInProcess.Origin
,   from_loc = ShipLogInProcess.Origin
,   to_loc = coalesce( ShipperLocation, Container.ContainerCode)
,   on_hand =
		(	select
				coalesce(min(part_online.on_hand), 0) + sum(SL2.Quantity)
			from
				FT.vwCommonSerial_ShipLogInProcess SL2
				left outer join part_online
					on SL2.Part = part_online.part
			where
				SL2.Serial <= ShipLogInProcess.Serial
				and SL2.Part = ShipLogInProcess.Part
				and SL2.Status = 'A'
		)
,   status = ShipLogInProcess.Status
,   shipper = ShipLogInProcess.Origin + '-' + convert (varchar, ShipLogInProcess.Shipper)
,   unit = ShipLogInProcess.RcvdUnit
,   std_quantity = ShipLogInProcess.Quantity
,   cost = ShipLogInProcess.RcvdCost
,   plant = ShipLogInProcess.RcvdPlant
,   gl_account = '?'
,   std_cost = ShipLogInProcess.RcvdCost
,   user_defined_status = ShipLogInProcess.UserStatus
,   parent_serial = ShipLogInProcess.PalletSerial
,	field1 = ShipLogInProcess.field1
,	custom1 = ShipLogInProcess.AETCNumber
,	custom2 = ShipLogInProcess.BOL
,	ShipLogInProcess.lot
,	note=case when ShipLogInProcess.Status='H' then 'Certified to release - ' + ShipLogInProcess.SSR_ID  else '' end
from
	FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
	join @ShipperContainers Container
		on ShipLogInProcess.Shipper = Container.Shipper
where
	ShipLogInProcess.Origin = @OriginPlant
order by
	ShipLogInProcess.Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Update part online. */
--- <Update rows="1+">
set	@TableName = 'dbo.part_online'

update
	po
set	on_hand = dbo.udf_GetPartQtyOnHand(po.part)
from
	dbo.part_online po
where
	exists
		(	select
				*
			from
				dbo.PODetail pd
			where
				pd.Part = po.part
		) 

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--if	@RowCount <= 0 begin
--	set	@Result = 999999
--	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
--	rollback tran @ProcName
--	return
--end
--- </Update>

/*	Mark records as processed and ready to retransmit. */
--- <Update rows="1+">
set	@TableName = 'FT.CommonSerialShipLog'

update
    CommonSerialShipLog
set
    RowStatus = 0
,   ReceiveDT = @TranDT
,   PONumber = ShipLogInProcess.PONumber
,   RcvdUnit = ShipLogInProcess.RcvdUnit
,   RcvdPrice = ShipLogInProcess.RcvdPrice
,   RcvdCost = ShipLogInProcess.RcvdCost
,   RcvdWeight = ShipLogInProcess.RcvdWeight
,   RcvdTareWeight = ShipLogInProcess.RcvdTareWeight
from
    FT.CommonSerialShipLog CommonSerialShipLog
    join FT.vwCommonSerial_ShipLogInProcess ShipLogInProcess
        on CommonSerialShipLog.Serial = ShipLogInProcess.Serial
where
    ShipLogInProcess.Origin = @OriginPlant

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

drop table
	tempdb..CommonSerialReceiveSerials_OneAtATime
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.ftsp_CommonSerialReceiveSerials
	@Param1 = @Param1
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
