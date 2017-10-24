SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EDISUS].[usp_Stage_2_ManualImport]
	@Release varchar(50) 
,	@CustomerPart varchar(50)
,	@Part varchar(50)
,	@Destination varchar(20)
,	@ReleaseQty numeric(20,6)
,	@ReleaseDT datetime
,	@CustomerPOLine varchar(50) = null
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

---	</ArgumentValidation>

--- <Body>
declare
	@GUID uniqueidentifier
	
/*  Insert a planning header row once */
if not exists
	(	select
			1
		from
			EDISUS.PlanningHeaders_ManualImport ph
		where
			ph.Release = @Release ) begin
			
	set 
		@GUID = newid()
				
	--- <Insert rows="1">
	set	@TableName = 'EDISUS.PlanningHeaders_ManualImport'

	insert into
		EDISUS.PlanningHeaders_ManualImport
	(
		Release
	,	RawDocumentGUID
	,	Status
	,	Type
	,	DocType
	,	DocNumber
	)
	select
		Release = @Release
	,	RawDocumentGUID = @GUID
	,	Status = 0
	,	Type = 1
	,	DocType = 'ExclRP'
	,	DocNumber = @Release
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount = 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end



/*  Add leading zeros to customer part if necessary (imported file type CSV will not preserve XLSX data formating, therefore drops leading zeros)  */
declare
	@tempCustomerPart varchar(25)
		
select
	@tempCustomerPart = max(oh.customer_part)
from
	dbo.order_header oh
where
	oh.customer_part like '%' + @CustomerPart
	and oh.status = 'A'
	
if (@CustomerPart <> @tempCustomerPart) begin

	if (substring(@tempCustomerPart, 0, 1) = 0) begin
		select 
			@CustomerPart = @tempCustomerPart
	end
	
end	



/*  Validate sales orders are set up for planning release import  */
-- <Validate>
set			@CallProcName = 'dbo.usp_PlanningReleaseManualImport_Validate'
execute		@ProcReturn = dbo.usp_PlanningReleaseManualImport_Validate
			@CustomerPart = @CustomerPart,
			@Destination = @Destination,
			@TranDT = @TranDT out,
			@Result = @ProcResult out
	       
set @Error = @@Error
if @Error != 0 begin
	set	@Result = 900501
	--RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return @Result
end
if @ProcResult != 0 begin
	set	@Result = 900502
	--RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
-- </Validate>



/*  Insert a planning release detail row as long as it doesn't already exist  */
if not exists
	(
		select
			1
		from
			EDISUS.PlanningReleases_ManualImport pr
		where
			pr.ReleaseNo = @Release
			and pr.CustomerPart = @CustomerPart
			and pr.ReleaseDT = @ReleaseDT
			and pr.ReleaseQty = @ReleaseQty ) begin

	select
		@GUID = ph.RawDocumentGUID
	from
		EDISUS.PlanningHeaders_ManualImport ph
	where
		ph.Release = @Release
	
		
	--- <Insert rows="1">
	set	@TableName = 'EDISUS.PlanningReleases_ManualImport'

	insert into
	EDISUS.PlanningReleases_ManualImport
	(
			Status
		,	Type
		,	RawDocumentGUID
		,	ReleaseNo
		,	ShipToCode
		,	CustomerPart
		--,	CustomerPOLine
		,	CustomerModelYear
		,	ReferenceNo
		,	ReleaseQty
		,	ReleaseDT
	)
	select
			Status = 0
		,	Type = 1
		,	RawDocumentGUID = @GUID
		--,	ReleaseNo = @Release
		,	ReleaseNo = @CustomerPOLine
		,	ShipToCode = @Destination
		,	CustomerPart = @CustomerPart
		--,	CustomerPOLine = @CustomerPOLine
		,	'P'
		,	ReferenceNo = @Part
		,	ReleaseQty = @ReleaseQty
		,	ReleaseDT = @ReleaseDT

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount = 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
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
GO
