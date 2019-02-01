SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_Putaway_Begin_Phys]
	@Operator varchar(10)
,   @fromloc varchar(20)
,   @toloc varchar(20)
,   @type  varchar(10) 
,   @plant varchar(5)
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

Declare @TranDT datetime
set @TranDT=getdate()

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
		if not exists(Select 1 from location where code=@fromloc) begin
				set	@Result = 999999
				RAISERROR ('This location %s is not exist', 16, 1, @fromloc)
				rollback tran @ProcName
				return
		end

		if not exists(Select 1 from hn.vw_Picklist_LocationValid where code=@fromloc and plant=@plant) begin
				set	@Result = 999999
				RAISERROR ('This location %s is from another warehouse ', 16, 1, @fromloc)
				rollback tran @ProcName
				return
		end
		--if not exists(Select 1 from object where location=@fromloc and quantity>0) begin
		--		set	@Result = 999999
		--		RAISERROR ('This location %s is clean ', 16, 1, @fromloc)
		--		rollback tran @ProcName
		--		return
		--end

		


/*	Update inventory location. */


	if not exists(select 1 from [HN].[Putaway_log] where Operator=@Operator and Status='InProcess' )  begin
				INSERT INTO [HN].[Putaway_log] ([Location],[Operator],[Date] ,[Status],[Type]) 
				VALUES(@fromloc,@Operator,Getdate(),'InProcess',@type ) 
	end

/*
Solicitado por Dorian Cano para no forzar la lectura de las series de las cajas, ya que en esta location se mueven
todo aquello que ya no cabe en las rackas.
Implementado por el problema de espacio encontrado en PILOT Freghit Service el 2018-08-24
Realizado por Roberto Larios.
*/
if @fromloc not like '%floor%'
begin
			declare
@TranType char(1) = 'G'
,   @Remark varchar(10) = 'Begin Phys'
,   @Notes varchar(50) = 'Begin a physical inventory.1'

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
,	operator
,	from_loc
,	to_loc
,	parent_serial
,	lot
,	weight
,	status
,	shipper
,	unit
,	std_quantity
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight
,	warehousefreightlot
)
select
o.serial
,	date_stamp = @TranDT
,	type = @TranType
,	o.part
,	o.quantity
,	remarks = @Remark
,	@Operator
,	from_loc = o.location
,	to_loc =@toloc
,	o.parent_serial
,	o.lot
,	o.weight
,	o.status
,	o.shipper
,	unit = o.unit_measure
,	o.std_quantity
,	o.plant
,	@Notes
,	o.package_type
,	std_cost = o.cost
,	o.user_defined_status
,	o.tare_weight
,	o.warehousefreightlot
from
dbo.object o
where o.location=@fromloc
	

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

--- <Update rows="*">
set	@TableName = 'dbo.object'

									update
dbo.object 
set
operator = @Operator
,	location =@toloc
,	last_date = @TranDT
,	last_time = @TranDT
from
dbo.object 
where location=@fromloc

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
--- </Body>
end

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
	@ProcReturn = FT.usp_PhysInv_BeginPhysical
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
