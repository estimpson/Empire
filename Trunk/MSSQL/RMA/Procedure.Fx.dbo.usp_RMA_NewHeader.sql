
/*
Create Procedure.Fx.dbo.usp_RMA_NewHeader.sql
*/

--use Fx
--go

if	objectproperty(object_id('dbo.usp_RMA_NewHeader'), 'IsProcedure') = 1 begin
	drop procedure dbo.usp_RMA_NewHeader
end
go

create procedure dbo.usp_RMA_NewHeader
	@User varchar(5)
,	@ShipToCode varchar(20)
,	@Reason varchar(255)
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
/*	Get new shipper number. */
declare @NextShipperID int

while
	exists
		(	select
				*
			from
				dbo.shipper s
			where
				id =
					(	select
							min(p.shipper) - 1
						from
							dbo.parameters p
					)
		) begin
	update
		dbo.parameters
	set
		shipper = shipper + 1
end

select
	@NextShipperID =
		(	select
				min(p.shipper) - 1
			from
				dbo.parameters p
		)

/*	Create RMA. */
--- <Insert rows="1">
set	@TableName = '[tableName]'

insert
	dbo.shipper
(	id
,	destination
,	status
,customer
,location
,staged_objs
,plant
,type
,invoiced
,invoice_number
,freight
,tax_percentage
,total_amount
,gross_weight
,net_weight
,tare_weight
,responsibility_code
,trans_mode
,pro_number
,notes
,time_shipped
,truck_number
,invoice_printed
,seal_number
,terms
,tax_rate
,staged_pallets
,container_message
,picklist_printed
,dropship_reconciled
,date_stamp
,platinum_trx_ctrl_num
,posted
,scheduled_ship_time
,currency_unit
,show_euro_amount
,cs_status
,bol_ship_to
,bol_carrier
,operator
,ExpediteCode
)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>

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
	@ProcReturn = dbo.usp_RMA_NewHeader
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
go

