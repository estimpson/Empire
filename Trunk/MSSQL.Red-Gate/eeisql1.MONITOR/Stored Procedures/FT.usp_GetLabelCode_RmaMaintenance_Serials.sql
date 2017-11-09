SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_GetLabelCode_RmaMaintenance_Serials]
	@Shipper int
as
set nocount on
set ansi_warnings off

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
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
--- </Tran>


--- <Validation>
/*  Shipper exists  */
if not exists (
		select
			1
		from
			dbo.shipper s
		where
			s.id = @Shipper ) begin

	RAISERROR ('Cannot print labels because shipper %d does not exist in the system.  Procedure %s', 16, 1, @Shipper, @ProcName)
	rollback tran @ProcName
	return
end

/*  Shipper has not been shipped  */
if not exists (
		select
			1
		from
			dbo.shipper s
		where
			s.date_shipped is null ) begin

	RAISERROR ('Cannot print labels because shipper %d has already been shipped.  Procedure %s', 16, 1, @Shipper, @ProcName)
	rollback tran @ProcName
	return
end

/*  Shipper has been staged  */
if not exists (
		select
			1
		from
			dbo.object o
		where
			o.shipper = @Shipper ) begin

	RAISERROR ('Cannot print labels because shipper %d is not staged.  Procedure %s', 16, 1, @Shipper, @ProcName)
	rollback tran @ProcName
	return
end
--- </Validation>


--- <Body>
select
	o.serial as Serial
from
	dbo.object o
where
	o.shipper = @Shipper
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

GO
