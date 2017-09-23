SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEA].[usp_Quality_PalletOrBox]
	@User varchar(5)
,	@Serial int
,	@NewStatus char(1)
,	@Notes varchar(254)
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEA.usp_Test
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
if	@NewStatus not in ('A', 'H') begin
	raiserror('Error encountered in %s.  Invalid status %s', 16, 1, @ProcName, @NewStatus)
	rollback
    return @Result
end
---	</ArgumentValidation>

--- <Body>
declare
	@newUserDefinedStatus varchar(30)
,	@newLocation varchar(10)

set	@newUserDefinedStatus = case when @NewStatus = 'H' then 'On Hold' when @NewStatus = 'A' then 'Approved' end
set @newLocation = case when @NewStatus = 'H' then 'AL-CERTI' when @NewStatus = 'A' then 'AL-WRHQUE' end

/*	Determine box or pallet. */
if	(	select
  			case when o.type is null then 'BOX' when o.type = 'S' then 'PALLET' end
  		from
  			dbo.object o
		where
			o.serial = @Serial
  	) = 'BOX' begin

	/*	Do quality on a box. */
	--- <Call>	
	set	@CallProcName = 'usp_InventoryControl_Quality'
	execute
		@ProcReturn = dbo.usp_InventoryControl_Quality
			@User = @User
		,	@Serial = @Serial
		,	@NewUserDefinedStatus = @newUserDefinedStatus
		,	@Notes = @Notes
		,	@TranDT = @TranDT out
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
	
	/*	Transfer box to appropriate location. */
	--- <Call>	
	set	@CallProcName = 'FT.ftsp_InvControl_Transfer'
	execute
		@ProcReturn = FT.ftsp_InvControl_Transfer
			@Operator = @User
		,	@Serial = @Serial
		,	@NewLocation = @newLocation
		,	@TranDT = @TranDT out
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
end
else begin

	/*	Do quality on a pallet. */
	--- <Call>	
	set	@CallProcName = 'usp_InventoryControl_QualityBoxesOnPallet'
	execute
		@ProcReturn = dbo.usp_InventoryControl_QualityBoxesOnPallet 
			@User = @User
		,	@PalletSerial = @Serial
		,	@NewUserDefinedStatus = @newUserDefinedStatus
		,	@Notes = @Notes
		,	@TranDT = @TranDT out
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
	
	/*	Transfer box to appropriate location. */
	--- <Call>	
	set	@CallProcName = 'FT.usp_InvControl_TransferPallet'
	execute
		@ProcReturn = FT.usp_InvControl_TransferPallet
			@Operator = @User
		,	@PalletSerial = @Serial
		,	@Location = @newLocation
		,	@Notes = 'Pallet transferred due to quality.'
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn not in (0, 100) begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult not in (0, 100) begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
end
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
	@User varchar(5) = 'ES'
,	@Serial int = 1132458
,	@NewStatus char(1) = 'H'
,	@Notes varchar(254) = 'unseated w3'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EEA.usp_Quality_PalletOrBox
	@User = @User
,	@Serial = @Serial
,	@NewStatus = @NewStatus
,	@Notes = @Notes
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.object o
where
	o.parent_serial = @Serial
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
