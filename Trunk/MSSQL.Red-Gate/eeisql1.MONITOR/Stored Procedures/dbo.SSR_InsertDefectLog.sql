SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SSR_InsertDefectLog](
		@Serial int,
		@type_defect varchar(50),
		@Quantity int,
		@Operator varchar(15),
		@Origin char(3),
		@Result int out) 
as


/*
begin tran
declare @Result int,
		@Serial int

set @Serial=34783493

exec MONITOR.dbo.SSR_InsertDefectLog
@Serial=@Serial,
@type_defect='BOX TAPING',
@Quantity=1,
@Operator='424',
@Origin='EEH',
@Result=@Result out

select @Result

select * from MONITOR.dbo.SSR_LogDefect_Report  where serial= @Serial

rollback tran

*/
SET nocount on
SET	@Result = 999999

DECLARE	@TranCount smallint,@ProcName sysname
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName
	
declare @TranDT datetime
set @TranDT=getdate()

--se comentario por mientras carol ingresado datos de SSR viejos y cerrados
--IF not EXISTS (	select 1
--				from dbo.view_SSRLogSerialHND 
--				where SSR_Status=1 and Serial=@Serial
--)BEGIN
--	set	@Result = 999999
--	RAISERROR ('This serial %i not exists in SSR Software or the SSRID is not approved', 16, 1,@Serial)
--	rollback tran @ProcName
--	return	@Result
--END

if exists (	select	1
			from	dbo.SSR_LogDefect_Report
			where	serial =@serial and type_defect=@type_defect)
begin
	set	@Result = 999999
	RAISERROR ('The combination Serial - Defect are already inserted. Please choose a new defect.', 16, 1)
	rollback tran @ProcName
	return	@Result
end

if @Quantity=0
begin
	set	@Result = 999999
	RAISERROR ('The Scrap Quantity cant be zero (0).', 16, 1)
	rollback tran @ProcName
	return	@Result
end


Insert into MONITOR.dbo.SSR_LogDefect_Report (serial,type_defect,quantity,RegisterDT,Origin,RegisterBy) 
values (@Serial,@type_defect,@Quantity,@TranDT,@Origin,@Operator)

set @Error = @@Error
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error executing function in Temporal Table SSR_LogDefect_Report', 16, 1)
	rollback tran @ProcName
	return	@Result
end

	
--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName 
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	II.	Return.
set	@Result =0
return	@Result
GO
