SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EDIStanley].[usp_Stage_2]
	@Release varchar(50) 
,	@CustomerPart varchar(50)
,	@Part varchar(50)
,	@ReleaseQty numeric(20,6)
,	@ReleaseDT datetime
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
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@GUID uniqueidentifier
	
/*  Insert a ship schedule header row once */	
if not exists
	(	select
			1
		from
			EDIStanley.ShipScheduleHeaders ssh
		where
			ssh.Release = @Release ) begin

	set 
		@GUID = newid()
		
--- <Insert rows="1">
	set	@TableName = 'EDIStanley.ShipScheduleHeaders'

	insert into
		EDIStanley.ShipScheduleHeaders
	(
		Status
	,	Type
	,	RawDocumentGUID
	,	DocumentImportDT
	,	DocType
	,	Release
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		Status = 0
	,	Type = 1
	,	RawDocumentGUID = @GUID
	,	DocumentImportDT = getdate()
	,	DocType = 'ExclRP'
	,	Release = @Release
	,	DocNumber = @Release
	,	ControlNumber = convert(varchar(8), getdate(), 114)
	,	DocumentDT = getdate()
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


/*  Insert a ship schedule detail row as long as it doesn't already exist  */
if not exists
	(
		select
			1
		from
			EDIStanley.ShipSchedules ss
		where
			ss.ReleaseNo = @Release
			and ss.CustomerPart = @CustomerPart
			and ss.ReleaseDT = @ReleaseDT
			and ss.ReleaseQty = @ReleaseQty ) begin

	select
		@GUID = ssh.RawDocumentGUID
	from
		EDIStanley.ShipScheduleHeaders ssh
	where
		ssh.Release = @Release

	--- <Insert rows="1">
	set	@TableName = 'EDIStanley.ShipSchedules'

	insert into
	EDIStanley.ShipSchedules
	(
			Status
		,	Type
		,	RawDocumentGUID
		,	ReleaseNo
		,	ShipToCode
		,	ShipFromCode
		,	CustomerPart
		,	ReferenceNo
		,	ReleaseQty
		,	ReleaseDT
	)
	select
			Status = 0
		,	Type = 1
		,	RawDocumentGUID = @GUID
		,	ReleaseNo = @Release
		,	ShipToCode = 'SUS'
		,	ShipFromCode = 'EEI'
		,	CustomerPart = @CustomerPart
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
		
		
/*  Insert a planning header row once */
if not exists
	(	select
			1
		from
			EDIStanley.PlanningHeaders ph
		where
			ph.Release = @Release ) begin
				
	--- <Insert rows="1">
	set	@TableName = 'EDIStanley.PlanningHeaders'

	insert into
		EDIStanley.PlanningHeaders
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


/*  Insert a planning release detail row as long as it doesn't already exist  */
if not exists
	(
		select
			1
		from
			EDIStanley.PlanningReleases pr
		where
			pr.ReleaseNo = @Release
			and pr.CustomerPart = @CustomerPart
			and pr.ReleaseDT = @ReleaseDT
			and pr.ReleaseQty = @ReleaseQty ) begin

	select
		@GUID = ph.RawDocumentGUID
	from
		EDIStanley.PlanningHeaders ph
	where
		ph.Release = @Release
		
	--- <Insert rows="1">
	set	@TableName = 'EDIStanley.PlanningReleases'

	insert into
	EDIStanley.PlanningReleases
	(
			Status
		,	Type
		,	RawDocumentGUID
		,	ReleaseNo
		,	ShipToCode
		,	CustomerPart
		,	CustomerModelYear
		,	ReferenceNo
		,	ReleaseQty
		,	ReleaseDT
	)
	select
			Status = 0
		,	Type = 1
		,	RawDocumentGUID = @GUID
		,	ReleaseNo = @Release
		,	'SUS'
		,	CustomerPart = @CustomerPart
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
