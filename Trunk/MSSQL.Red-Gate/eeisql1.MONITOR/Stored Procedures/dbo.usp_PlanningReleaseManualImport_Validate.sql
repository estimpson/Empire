SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_PlanningReleaseManualImport_Validate]
	@CustomerPart varchar(50)
,	@Destination varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILiteTek.usp_Test
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
-- An active blanket order exists for this part / destination
if not exists (
		select
			1
		from
			dbo.order_header oh
		where
			oh.customer_part = @CustomerPart
			and oh.destination = @Destination
			and oh.order_type = 'B'
			and coalesce(oh.status, '') = 'A' ) begin
	
	set	@Result = 100900
	RAISERROR ('An active blanket order does not exist for part %s, destination %s.', 16, 1, @CustomerPart, @Destination)
	rollback tran @ProcName
	return
end

-- An active order that is set up for planning release import exists for this part / destination
if not exists (
		select
			1
		from
			dbo.order_header oh
		where
			oh.customer_part = @CustomerPart
			and oh.destination = @Destination
			and oh.order_type = 'B'
			and coalesce(oh.status, '') = 'A' 
			and coalesce(oh.model_year, '') = 'P' ) begin
	
	set	@Result = 100901
	RAISERROR ('Model year needs to be set to P for an active order for part %s, destination %s.', 16, 1, @CustomerPart, @Destination)
	rollback tran @ProcName
	return
end

-- Only one order is set up for planning release import for this part / destination
if ( (
		select
			count(1)
		from
			dbo.order_header oh
		where
			oh.customer_part = @CustomerPart
			and oh.destination = @Destination
			and oh.order_type = 'B'
			and coalesce(oh.status, '') = 'A' 
			and coalesce(oh.model_year, '') = 'P' ) > 1 ) begin
	
	set	@Result = 100902
	RAISERROR ('More than one order has model year set to P for part %s, destination %s.', 16, 1, @CustomerPart, @Destination)
	rollback tran @ProcName
	return
end		
	
-- Make sure the model year will be checked for this destination
if not exists (
		select
			1
		from
			dbo.edi_setups es
		where
			es.destination = @Destination
			and es.check_model_year = 'Y' ) begin
	
	--- <Update rows="1">
	set	@TableName = 'dbo.edi_setups'

	update
		es
	set
		check_model_year = 'Y'
	from
		dbo.edi_setups es
	where
		es.destination = @Destination
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount = 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end

-- Make sure the parent_destination is correct in edi_setups
if ( (
		select
			coalesce(es.parent_destination, '')
		from
			dbo.edi_setups es
		where
			es.destination = @Destination ) <> @Destination ) begin
		
	--- <Update rows="1">
	set	@TableName = 'dbo.edi_setups'
		
	update
		es
	set
		es.parent_destination = @Destination
	from
		dbo.edi_setups es
	where
		es.destination = @Destination	
			
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount = 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
---	</ArgumentValidation>


--- <Body>

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



GO
