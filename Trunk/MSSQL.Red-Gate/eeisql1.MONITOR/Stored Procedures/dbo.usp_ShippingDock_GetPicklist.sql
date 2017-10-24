SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_ShippingDock_GetPicklist]
	@ShipperID int
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

---	</ArgumentValidation>

--- <Body>
/*	Distribute release plans for all orders on this shipper... */
/*	... if needed, create table to hold current releases. */
if	object_id('tempdb.dbo.##BlanketOrderReleases_Edit') is null begin

	create table ##BlanketOrderReleases_Edit
	(	SPID int default @@SPID
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	ActiveOrderNo int
	,	ReleaseNo varchar(30)
	,	ReleaseDT datetime
	,	ReleaseType char(1)
	,	QtyRelease numeric(20,6)
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	SPID
		,	ActiveOrderNo
		,	ReleaseNo
		,	ReleaseDT
		)
	)
end

/*	... delete any releases that may currently be left-over in the table. */
delete
	##BlanketOrderReleases_Edit
where
	SPID = @@SPID

/*	... store all current releases related to this shipper. */
insert
	##BlanketOrderReleases_Edit
(	ActiveOrderNo
,	ReleaseNo
,	ReleaseDT
,	ReleaseType
,	QtyRelease
)
select
	bor.ActiveOrderNo
,   bor.ReleaseNo
,   bor.ReleaseDT
,	bor.ReleaseType
,   bor.QtyRelease
from
	BlanketOrderReleases bor
where
	bor.ActiveOrderNo in
	(	select
			boa.ActiveOrderNo
		from
			dbo.BlanketOrderAlternates boa
		where
			boa.AlternateOrderNo in
			(	select
					sd.order_no
				from
					dbo.shipper_detail sd
				where
					sd.shipper = @ShipperID
			)
	)
order by
	bor.ReleaseDT
,	bor.ReleaseNo

/*	... Perform distribution. */
--- <Call>	
set	@CallProcName = 'dbo.usp_GetBlanketOrderDistributedReleases'
execute
	@ProcReturn = dbo.usp_GetBlanketOrderDistributedReleases
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = 0

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
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

/*	... Write changes back to order. */
--- <Call>	
set	@CallProcName = 'dbo.usp_SaveBlanketOrderDistributedReleases'
execute
	@ProcReturn = dbo.usp_SaveBlanketOrderDistributedReleases
	@TranDT = @TranDT out
,	@Result = @ProcResult out

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
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>
--- </Body>

if	@TranCount = 0 begin
	commit tran @ProcName
end

---	<Return>
/*	Return results. */
select
	eeivw_form_picklist.std_pack
,	eeivw_form_picklist.order_header_zone_code
,	eeivw_form_picklist.order_header_dock_code
,	eeivw_form_picklist.order_header_package_type
,	eeivw_form_picklist.order_header_line_feed_code
,	eeivw_form_picklist.shipper_destination
,	eeivw_form_picklist.shipper_date_stamp
,	eeivw_form_picklist.shipper_ship_via
,	eeivw_form_picklist.shipper_scheduled_ship_time
,	eeivw_form_picklist.shipper_detail_customer_part
,	eeivw_form_picklist.shipper_detail_part
,	eeivw_form_picklist.shipper_detail_qty_required
,	eeivw_form_picklist.shipper_id
,	eeivw_form_picklist.part_inventory_primary_location
,	eeivw_form_picklist.part_online_on_hand
,	eeivw_form_picklist.destination_name
,	eeivw_form_picklist.parameters_company_name
,	eeivw_form_picklist.shipper_detail_qty_original
,	eeivw_form_picklist.shipper_detail_qty_packed
,	eeivw_form_picklist.partonlineonhand
,	eeivw_form_picklist.app_qty
,	eeivw_form_picklist.non_app_qty
,	eeivw_form_picklist.accum
,	eeivw_form_picklist.serial
,	eeivw_form_picklist.pull_qty
,	eeivw_form_picklist.object_location
,	eeivw_form_picklist.object_status
,	eeivw_form_picklist.shipper_notes
,	eeivw_form_picklist.itnumber
,	eeivw_form_picklist.shipper_detail_part_original
,	eeivw_form_picklist.object_parent_serial
from
	eeivw_form_picklist
where
	eeivw_form_picklist.accum <= eeivw_form_picklist.pull_qty
	and eeivw_form_picklist.shipper_id = @ShipperID

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
	@shipperID int

set	@shipperID = 58953

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_ShippingDock_GetPicklist
	@ShipperID = @shipperID
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
