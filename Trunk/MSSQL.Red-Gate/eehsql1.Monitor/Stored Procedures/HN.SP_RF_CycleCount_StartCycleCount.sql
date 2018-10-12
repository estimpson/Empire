SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [HN].[SP_RF_CycleCount_StartCycleCount](
		@Operator int,
		@Location varchar(10),
		@CycleCountId int out,
		@Result int out )
as
/*
begin tran

declare	@Result int, @CycleCountId int


exec HN.SP_RF_CycleCount_StartCycleCount
		@Operator = 'MON',
		@Location = '0202C-1',
		@CycleCountId = @CycleCountId out,
		@Result = @Result out

select	@Result, @CycleCountId

select	*
from	hn.MAT_CycleCount_Warehouse_Header
where	CycleCountID = @CycleCountId

select	*
from	hn.MAT_CycleCount_Warehouse_Detail
where	CycleCountID = @CycleCountId

rollback
*/


SET nocount ON
SET	@Result = 999999

DECLARE	@TranCount smallint

--<Tran Required=Yes AutoCreate=Yes>
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION SP_RF_CycleCount_StartCycleCount
ELSE
	SAVE TRANSACTION SP_RF_CycleCount_StartCycleCount

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer, @TranDT datetime


set	@TranDT = getdate()

--	Argument Validation:
--		Operator required:
if	not exists
	(	select 	1
		from	employee
		where	operator_code = @operator) begin

	set	@result = 60001
	rollback tran SP_RF_CycleCount_StartCycleCount
	raiserror (@result, 16, 1, @operator)
	return	@result
end

--		location required:
if	not exists
	(	select 	1
		from	location
		where	code = @Location
				and group_no != 'Inventory' ) begin
	set	@result = 100001
	rollback tran SP_RF_CycleCount_StartCycleCount
	raiserror ('Location %s does not exists or is already on inventory', 16, 1, @Location)
	return	@result
end

if	exists(	select	1
			from	hn.MAT_CycleCount_Warehouse_Header
			where	location = @Location
					and Status = 'A' ) begin
	set	@result = 99999
	rollback tran SP_RF_CycleCount_StartCycleCount
	raiserror ('There still an active Cyclecount for %s', 16, 1, @Location)
	return	@result
end


insert	HN.MAT_CycleCount_Warehouse_Header(InitialGroup,Location, Operator, Status,TransDT )
select	group_no, code, @Operator, Status = 'A',
		@TranDT
from	location
where	code = @Location

select	@Error = @@Error, @RowCount = @@ROWCOUNT
if	@Error != 0 begin
	set	@Result = 99999
	RAISERROR ('Error starting the Cycle count for %s', 16, 1, @Location)
	rollback tran SP_RF_CycleCount_StartCycleCount
	return	@Result
end
	
if	@RowCount != 1 begin
	set	@Result = 99999
	RAISERROR ('No row where register in MAT_CycleCount_Warehouse_Header for %s', 16, 1, @Location)
	rollback tran SP_RF_CycleCount_StartCycleCount
	return	@Result
end


set	@CycleCountId = @@IDENTITY 

insert into HN.MAT_CycleCount_Warehouse_Detail( CycleCountID, OriginalLocation, Quantity, Serial, TransDT)
select	@CycleCountId, location, std_quantity,
		serial, @TranDT
from	object
where	location = @Location

select	@Error = @@Error, @RowCount = @@ROWCOUNT
if	@Error != 0 begin
	set	@Result = 99999
	RAISERROR ('Error registing the serial for %s', 16, 1, @Location)
	rollback tran SP_RF_CycleCount_StartCycleCount
	return	@Result
end
	
if	@RowCount != 1 begin
	set	@Result = 99999
	RAISERROR ('No row where register in MAT_CycleCount_Warehouse_Header for %s', 16, 1, @Location)
	rollback tran SP_RF_CycleCount_StartCycleCount
	return	@Result
end


--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction SP_RF_CycleCount_StartCycleCount
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	II.	Return.
set	@Result = 0
return	@Result
GO
