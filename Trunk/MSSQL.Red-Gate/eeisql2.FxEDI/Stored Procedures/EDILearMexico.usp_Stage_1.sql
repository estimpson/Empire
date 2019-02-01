SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDILearMexico].[usp_Stage_1]
	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
as
set nocount on
set ansi_warnings on
set @Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer

set @ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI.usp_Test
--- </Error Handling>

--- <Tran Required=No AutoCreate=No TranDTParm=Yes>
set @TranDT = coalesce(@TranDT, getdate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
if	@Debug = 0 begin
	declare @toc time
end

/*	Look for documents already in the queue.*/
IF	EXISTS
	(	SELECT
			1
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '862'
			AND  ed.EDIStandard = 'LearMexico' 
			AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	)
	OR EXISTS
	(	SELECT
			1
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '830'
			AND  ed.EDIStandard = 'LearMexico' 
			AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) BEGIN
	GOTO queueError
END

/*	Move new and reprocessed 2040 862s and 830s to Staging. */
/*		Set new and requeued documents to in process.*/
--- <Update rows="*">
SET	@TableName = 'EDI.EDIDocuments'

IF	EXISTS
	(	SELECT
			1
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '862'
			AND  ed.EDIStandard = 'LearMexico' 
			AND ed.Status IN
				(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
				,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
				)
	) BEGIN
	
	UPDATE
		ed
	SET
		Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	FROM
		EDI.EDIDocuments ed
	WHERE
		ed.Type = '862'
		AND  ed.EDIStandard = 'LearMexico' 
		AND ed.Status IN
			(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
			,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
			)
		AND NOT EXISTS
		(	SELECT
				1
			FROM
				EDI.EDIDocuments ed
			WHERE
				ed.Type = '862'
				AND  ed.EDIStandard = 'LearMexico' 
				AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
		)
	
	SELECT
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		SET	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		GOTO queueError
	END
END
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDI.EDIDocuments'

if	exists
	(	select
			1
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '830'
			and  ed.EDIStandard = 'LearMexico' 
			and ed.Status in
				(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
				,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
				)
	) begin
		
	update
		ed
	set
		Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and  ed.EDIStandard = 'LearMexico' 
		and ed.Status in
			(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
			,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
			)
		and not exists
		(	select
				1
			from
				EDI.EDIDocuments ed
			where
				ed.Type = '830'
				and  ed.EDIStandard = 'LearMexico' 
				and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
		)

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		GOTO queueError
	END
END
--- </Update>

/*	Prepare data for Staging Tables...*/
/*		- prepare Ship Schedules...*/
if	exists
	(	select
			1
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '862'
			and  ed.EDIStandard = 'LearMexico' 
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) begin

/*			- prepare Ship Schedules Headers.*/
	create table
		#ShipScheduleHeaders
	(	RawDocumentGUID uniqueidentifier
    ,	Data xml
	,	DocumentImportDT datetime
	,	TradingPartner varchar(50)
	,	DocType varchar(6)
	,	Version varchar(20)
	,	ReleaseNo varchar(30)
	,	DocNumber varchar(50)
	,	ControlNumber varchar(10)
	,	DocumentDT datetime
	,	RowID int not null identity(1, 1) primary key
	)

	create primary xml index ix1ss on #ShipScheduleHeaders (Data)
	create xml index ix2ss on #ShipScheduleHeaders (Data) using xml index ix1ss for path
	--create xml index ix3 on #PlanningHeaders (Data) using xml index ix1 for value
	--create xml index ix4 on #PlanningHeaders (Data) using xml index ix1 for property

	insert
		#ShipScheduleHeaders
	(	RawDocumentGUID
    ,	Data
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)

	select
		RawDocumentGUID = ed.GUID
	,	Data = ed.Data
	,	DocumentImportDT = ed.RowCreateDT
	,	TradingPartner
	,	DocType = ed.Type
	,	Version
	,	ReleaseNo = coalesce(ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0328"])[1]', 'varchar(30)'), ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0127"])[1]', 'varchar(30)'))
	,	DocNumber
	,	ControlNumber
	,	DocumentDT = coalesce(ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0373"])[2]', 'datetime'), ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0373"])[1]', 'datetime'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and  ed.EDIStandard = 'LearMexico' 
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

		if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select '#ShipScheduleHeaders', @toc

		select
			*
		from
			#ShipScheduleHeaders ph
	end

/*			- prepare Ship Schedules Supplemental.*/

	create table
		#ShipScheduleSupplemental
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) --Dock Code
	,	UserDefined2 varchar(50) --Line Feed Code	
	,	UserDefined3 varchar(50) --Reserve Line Feed Code
	,	UserDefined4 varchar(50) --Zone code
	,	UserDefined5 varchar(50)
	,	UserDefined6 varchar(50)
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	,	UserDefined11 varchar(50) --11Z
	,	UserDefined12 varchar(50) --12Z
	,	UserDefined13 varchar(50) --13Z
	,	UserDefined14 varchar(50) --14Z
	,	UserDefined15 varchar(50) --15Z
	,	UserDefined16 varchar(50) --16Z
	,	UserDefined17 varchar(50) --17Z
	,	UserDefined18 varchar(50)
	,	UserDefined19 varchar(50)
	,	UserDefined20 varchar(50)
	)

	-- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetShipScheduleSupplemental'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleSupplemental
			@Result = @ProcResult out
		,	@Debug = @Debug

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetShipScheduleSupplemental', @toc

		select
			*
		from
			#ShipScheduleSupplemental
	end
	

	
/*			- prepare Ship Schedules Accums.*/

Create table
		#ShipScheduleAccums 
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	ReceivedAccum varchar(50)
	,	ReceivedAccumBeginDT varchar(50)
	,	ReceivedAccumEndDT varchar(50)
	,	ReceivedQty varchar(50)
	,	ReceivedQtyDT varchar(50)
	,	ReceivedShipper varchar(50)
	
	)

	-- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetShipScheduleAccums'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleAccums
			@Result = @ProcResult out
		,	@Debug = @Debug

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetShipScheduleAccums', @toc

		select
			*
		from
			#ShipScheduleAccums
	end

	
	
	

/*			- Prepare Ship Schedules Auth Accums.*/
Create table
		#ShipScheduleAuthAccums 
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	AuthAccum varchar(50)
	,	AuthAccumBeginDT varchar(50)
	,	AuthAccumEndDT varchar(50)
	
	)

	-- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetShipScheduleAuthAccums'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleAuthAccums
			@Result = @ProcResult out
		,	@Debug = @Debug

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetShipScheduleAuthAccums', @toc

		select
			*
		from
			#ShipScheduleAuthAccums
	end

/*			- prepare Ship Schedules Releases.*/


create table
		#ShipSchedules 
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	DateDue varchar(50)
	,	QuantityDue varchar(50)
	,	QuantityType varchar(50)
	
	)

	-- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetShipScheduleReleases'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleReleases
			@Result = @ProcResult out
		,	@Debug = @Debug

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetShipScheduleReleases', @toc

		select
			*
		from
			#ShipSchedules
	end

END

/*		- prepare Release Plans...*/
if	exists
	(	select
			*
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '830'
			and  ed.EDIStandard = 'LearMexico' 
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) 
	begin
/*			- prepare Release Plans Headers.*/
	create table
		#PlanningHeaders
	(	RawDocumentGUID uniqueidentifier
    ,	Data xml
	,	DocumentImportDT datetime
	,	TradingPartner varchar(50)
	,	DocType varchar(6)
	,	Version varchar(20)
	,	ReleaseNo varchar(30)
	,	DocNumber varchar(50)
	,	ControlNumber varchar(10)
	,	DocumentDT datetime
	,	RowID int not null identity(1, 1) primary key
	)

	create primary xml index ix1 on #PlanningHeaders (Data)
	create xml index ix2 on #PlanningHeaders (Data) using xml index ix1 for path
	--create xml index ix3 on #PlanningHeaders (Data) using xml index ix1 for value
	--create xml index ix4 on #PlanningHeaders (Data) using xml index ix1 for property

	insert
		#PlanningHeaders
	(	RawDocumentGUID
    ,	Data
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID = ed.GUID
	,	Data = ed.Data
	,	DocumentImportDT = ed.RowCreateDT
	,	TradingPartner
	,	DocType = ed.Type
	,	Version
	,	ReleaseNo = coalesce
			(	nullif
				(	ed.Data.value('(/TRN-830/SEG-BFR/DE[@code="0328"])[1]', 'varchar(30)')
				,	''
				)
			,	ed.Data.value('(/TRN-830/SEG-BFR/DE[@code="0127"])[1]', 'varchar(30)')
			)
	,	DocNumber
	,	ControlNumber
	,	DocumentDT = ed.Data.value('(/TRN-830/SEG-BFR/DE[@code="0373"])[3]', 'datetime')
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and ed.EDIStandard = 'LearMexico'
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select '#PlanningHeaders', @toc

		select
			*
		from
			#PlanningHeaders ph
	end

/*			- prepare Release Plans Supplemental.*/
	create table
		#PlanningSupplemental
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) --Dock Code
	,	UserDefined2 varchar(50) --Line Feed Code	
	,	UserDefined3 varchar(50) --Reserve Line Feed Code
	,	UserDefined4 varchar(50) --Zone code
	,	UserDefined5 varchar(50)
	,	UserDefined6 varchar(50)
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	,	UserDefined11 varchar(50) --11Z
	,	UserDefined12 varchar(50) --12Z
	,	UserDefined13 varchar(50) --13Z
	,	UserDefined14 varchar(50) --14Z
	,	UserDefined15 varchar(50) --15Z
	,	UserDefined16 varchar(50) --16Z
	,	UserDefined17 varchar(50) --17Z
	,	UserDefined18 varchar(50)
	,	UserDefined19 varchar(50)
	,	UserDefined20 varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetPlanningsupplemental'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetPlanningsupplemental
			@Result = @ProcResult out
		,	@Debug = @Debug

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetPlanningsupplemental', @toc

		select
			*
		from
			#PlanningSupplemental
	end

--Select * From @PlanningSupplementalTemp1
--Select * From @PlanningSupplementalTemp2
--Select * From @PlanningSupplementalTemp3
--Select * From @PlanningSupplemental

--Rollback Transaction

/*			- prepare Release Plans Accums.*/
	create table
		#PlanningAccums
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	ReceivedAccum varchar(50)
	,	ReceivedAccumBeginDT varchar(50)
	,	ReceivedAccumEndDT varchar(50)
	,	ReceivedQty varchar(50)
	,	ReceivedQtyDT varchar(50)
	,	ReceivedShipper varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetPlanningAccums'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetPlanningAccums
			@Result = @ProcResult out
		,	@Debug = @Debug
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>
	
	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetPlanningAccums', @toc

		select
			*
		from
			#PlanningAccums
	end

/* -Prepare Planning Auth Accums.*/
	create table
		#PlanningAuthAccums
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	AuthAccum varchar(50)
	,	AuthAccumBeginDT varchar(50)
	,	AuthAccumEndDT varchar(50)
	,	FabAccum varchar(50)
	,	FabAccumBeginDT varchar(50)
	,	FabAccumEndDT varchar(50)
	,	RawAccum varchar(50)
	,	RawAccumBeginDT varchar(50)
	,	RawAccumEndDT varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetPlanningAuthAccums'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetPlanningAuthAccums
			@Result = @ProcResult out
		,	@Debug = @Debug
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>
	
	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetPlanningAuthAccumss', @toc

		select
			*
		from
			#PlanningAuthAccums
	end
	
/*			- prepare Release Plan Releases.*/
	create table
		#PlanningReleases
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	DateDue varchar(50)
	,	QuantityDue varchar(50)
	,	QuantityType varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDILearMexico.usp_Stage1_GetPlanningReleases'
	execute
		@ProcReturn = EDILearMexico.usp_Stage1_GetPlanningReleases
			@Result = @ProcResult out
		,	@Debug = @Debug
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		--rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		--rollback tran @ProcName
		return
	end
	--- </Call>
	
	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select 'EDILearMexico.usp_Stage1_GetPlanningAuthAccumss', @toc

		select
			*
		from
			#PlanningReleases
	end
end

/*	Write data to Staging Tables...*/
/*		- write Ship Schedules...*/
/*			- write Headers.*/

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipScheduleHeaders')
) begin

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipScheduleHeaders')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipScheduleHeaders'

	insert
		[MONITOR].EDILearMexico.StagingShipScheduleHeaders
	(	RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	Release
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	from
		#ShipScheduleHeaders fh

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END

/*			- write Supplemental.*/
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipScheduleSupplemental')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipScheduleSupplemental'
	
	insert 
		[MONITOR].EDILearMexico.StagingShipScheduleSupplemental
	(	RawDocumentGUID
    ,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
    ,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 
	,	UserDefined12 
	,	UserDefined13 
	,	UserDefined14 
	,	UserDefined15 
	,	UserDefined16 
	,	UserDefined17 
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
    )
    select
    RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
  ,		UserDefined1 -- Dock Code
	,	UserDefined2 -- Line Feed Code
	,	UserDefined3 -- Zone Code
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 --Line11
	,	UserDefined12 --Line12
	,	UserDefined13 --Line13
	,	UserDefined14 --Line14
	,	UserDefined15 --Line15
	,	UserDefined16 --Line16
	,	UserDefined17 --Line17
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
    from
        #ShipScheduleSupplemental fs
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END

/*			- write Accums.*/
----------------------------------------------------------------------------------------------------------------------

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipScheduleAccums')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipScheduleAccums'

	insert  [MONITOR].EDILearMexico.StagingShipScheduleAccums
    (	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
  ,	ReferenceNo
  ,	LastQtyReceived
  ,	LastQtyDT
	,	LastShipper
  ,	LastAccumQty
  ,	LastAccumDT 

    )
    select
   RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo = ''
	,	LastQtyReceived = nullif(ReceivedQty,'')
	,	LastQtyDT = case		when datalength(ReceivedQtyDT) = '6'
												then edi.udf_GetDT('YYMMDD', ReceivedQtyDT)
												when datalength(ReceivedQtyDT) = '8'
												then edi.udf_GetDT('CCYYMMDD', ReceivedQtyDT)
												else convert(datetime, ReceivedQtyDT)
								End
		, LastShipper =  ReceivedShipper
		, LastAccumQty = nullif(ReceivedAccum,'')
		, LastAccumDT = case		when datalength(ReceivedAccumEndDT) = '6'
														then edi.udf_GetDT('YYMMDD', ReceivedAccumEndDT)
														when datalength(ReceivedAccumEndDT) = '8'
														then edi.udf_GetDT('CCYYMMDD', ReceivedAccumEndDT)
														else convert(datetime, ReceivedAccumEndDT)
								End
    from
        #ShipScheduleAccums
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipScheduleAuthAccums')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipScheduleAuthAccums'

	insert
		[MONITOR].EDILearMexico.StagingShipScheduleAuthAccums
	(	
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
  ,	PriorCUMStartDT
  ,	PriorCUMEndDT
  ,	PriorCUM
	)
     select
    RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
  , PriorCUMStartDT =  case		when datalength(AuthAccumBeginDT) = '6'
												then edi.udf_GetDT('YYMMDD', AuthAccumBeginDT)
												when datalength(AuthAccumBeginDT) = '8'
												then edi.udf_GetDT('CCYYMMDD', AuthAccumBeginDT)
												else convert(datetime, AuthAccumBeginDT)
												End
    ,   PriorCUMEndDT = case		when datalength(AuthAccumEndDT) = '6'
												then edi.udf_GetDT('YYMMDD', AuthAccumEndDT)
												when datalength(AuthAccumEndDT) = '8'
												then edi.udf_GetDT('CCYYMMDD', AuthAccumEndDT)
												else convert(datetime, AuthAccumEndDT)
												End
    ,   PriorCUM = nullif(AuthAccum,'')
    from
        #ShipScheduleAuthAccums
	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END

/*			- write Releases.*/
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#ShipSchedules')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipSchedules'

	insert
		[MONITOR].EDILearMexico.StagingShipSchedules
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined5
	,	ScheduleType
	,	ReleaseQty
	,	ReleaseDT
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined5
	,	QuantityType
	,	ReleaseQty = convert(numeric(20,6),nullif(QuantityDue,''))
	,	ReleaseDT = case		when datalength(DateDue) = '6'
												then edi.udf_GetDT('YYMMDD', DateDue)
												when datalength(DateDue) = '8'
												then edi.udf_GetDT('CCYYMMDD', DateDue)
												else convert(datetime, DateDue)
												End
	from
		#ShipSchedules
	

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END
END
----------------------------------------------------------------------------------------------------------
/*		- write Release Plans...*/
/*			- write Headers.*/
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#PlanningHeaders')
) begin

	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#PlanningHeaders')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingPlanningHeaders'

	insert
		[MONITOR].EDILearMexico.StagingPlanningHeaders
	(	RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	Release
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	from
		#PlanningHeaders fh

	select
		@Error = @@Error
	,	@RowCount = @@Rowcount

	if	@Error != 0 begin
		set @Result = 999999
		raiserror ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Supplemental.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#PlanningSupplemental')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingShipScheduleSupplemental'
	
	insert 
		[MONITOR].EDILearMexico.StagingPlanningSupplemental
	(	RawDocumentGUID
    ,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 
	,	UserDefined12 
	,	UserDefined13 
	,	UserDefined14 
	,	UserDefined15 
	,	UserDefined16 
	,	UserDefined17 
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
    )
    select
    RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
  ,	UserDefined1 -- Dock Code
	,	UserDefined2 -- Line Feed Code
	,	UserDefined3 -- Zone Code
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 --Line11
	,	UserDefined12 --Line12
	,	UserDefined13 --Line13
	,	UserDefined14 --Line14
	,	UserDefined15 --Line15
	,	UserDefined16 --Line16
	,	UserDefined17 --Line17
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
   from
       #PlanningSupplemental

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Insert>
END

/*			- write Accums.*/
------------------------------------------------------------------------------------------------------------------------
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#PlanningAccums')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingPlanningAccums'

	insert
		[MONITOR].EDILearMexico.StagingPlanningAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo
	,	LastQtyReceived
	,	LastQtyDT
	,	LastShipper
	,	LastAccumQty
	,	LastAccumDT 
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo = ''
	,	LastQtyReceived = nullif(ReceivedQty,'')
	,	LastQtyDT =
			case
				when datalength(ReceivedQtyDT) = '6'
					then edi.udf_GetDT('YYMMDD', ReceivedQtyDT)
				when datalength(ReceivedQtyDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', ReceivedQtyDT)
				else convert(datetime, ReceivedQtyDT)
			end
	,	LastShipper =  ReceivedShipper
	,	LastAccumQty = nullif(ReceivedAccum,'')
	,	LastAccumDT =
			case
				when datalength(ReceivedAccumEndDT) = '6'
					then edi.udf_GetDT('YYMMDD', ReceivedAccumEndDT)
				when datalength(ReceivedAccumEndDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', ReceivedAccumEndDT)
				else convert(datetime, ReceivedAccumEndDT)
			end
    from
		#PlanningAccums

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set @Result = 999999
		raiserror ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Planning Auth Accums.*/
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#PlanningAuthAccums')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingPlanningAuthAccums'

	insert
		[MONITOR].EDILearMexico.StagingPlanningAuthAccums
	(	
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCUM
	,	PriorCUMStartDT
	,	PriorCUMEndDT
	,	FabCUM
	,	FabCUMStartDT
	,	FabCUMEndDT
	,	RawCUM
	,	RawCUMStartDT
	,	RawCUMEndDT
	)
    select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCum = nullif(AuthAccum,'')
	,	PriorCUMStartDT =
			case
				when datalength(AuthAccumBeginDT) = '6'
					then edi.udf_GetDT('YYMMDD', AuthAccumBeginDT)
				when datalength(AuthAccumBeginDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', AuthAccumBeginDT)
				else convert(datetime, AuthAccumBeginDT)
			end
	,	PriorCUMEndDT =
			case
				when datalength(AuthAccumEndDT) = '6'
					then edi.udf_GetDT('YYMMDD', AuthAccumEndDT)
				when datalength(AuthAccumEndDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', AuthAccumEndDT)
				else convert(datetime, AuthAccumEndDT)
			end
	,	FabCum = nullif(FabAccum,'')
	,	FabCUMStartDT =
			case
				when datalength(FabAccumBeginDT) = '6'
					then edi.udf_GetDT('YYMMDD', FabAccumBeginDT)
				when datalength(FabAccumBeginDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', FabAccumBeginDT)
				else convert(datetime, FabAccumBeginDT)
			end
	,	FabCUMEndDT = 
			case
				when datalength(FabAccumEndDT) = '6'
					then edi.udf_GetDT('YYMMDD', FabAccumEndDT)
				when datalength(FabAccumEndDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', FabAccumEndDT)
				else convert(datetime, FabAccumEndDT)
			end
	,	RawCum = nullif(RawAccum,'')
	,	RawCUMStartDT =
			case
				when datalength(RawAccumBeginDT) = '6'
					then edi.udf_GetDT('YYMMDD', RawAccumBeginDT)
				when datalength(RawAccumBeginDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', RawAccumBeginDT)
				else convert(datetime, RawAccumBeginDT)
			end
	,	RawCUMEndDT =
			case
				when datalength(RawAccumEndDT) = '6'
					then edi.udf_GetDT('YYMMDD', RawAccumEndDT)
				when datalength(RawAccumEndDT) = '8'
					then edi.udf_GetDT('CCYYMMDD', RawAccumEndDT)
				else convert(datetime, RawAccumEndDT)
			end
    from
        #PlanningAuthAccums
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set @Result = 999999
		raiserror ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Releases.*/
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#PlanningReleases')
) begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDILearMexico.StagingPlanningReleases'

	insert
		[MONITOR].EDILearMexico.StagingPlanningReleases
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart 
	,	CustomerPO			
	,	CustomerPOLine		
	,	CustomerModelYear 
	,	CustomerECL	
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	ScheduleType
	,	QuantityQualifier
	,	Quantity 
	,	QuantityType
	,	DateType
	,	DateDT
	,	DateDTFormat
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart 
	,	CustomerPO			
	,	CustomerPOLine		
	,	CustomerModelYear 
	,	CustomerECL	
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	''
	,	''
	,	NULLIF(QuantityDue,'')
	,	QuantityType
	,	''
	,	case
			when datalength(DateDue) = '6' then edi.udf_GetDT('YYMMDD', DateDue)
			when datalength(DateDue) = '8' then edi.udf_GetDT('CCYYMMDD', DateDue)
			else convert(datetime, DateDue)
		end
	,	''
	FROM
		#PlanningReleases
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if @Error != 0 begin
		set @Result = 999999
		raiserror ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end
END
/*	Set in process documents to processed...*/
/*		- 862s.*/
IF	EXISTS
	(	SELECT
			*
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '862'
			AND  ed.EDIStandard = 'LearMexico' 
			AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) BEGIN
	--- <Update rows="*">
	SET	@TableName = 'EDILearMexico.ShipScheduleHeaders'
	
	UPDATE
		ed
	SET
		Status = 1 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Processed'))
	FROM
		EDI.EDIDocuments ed
	WHERE
		ed.Type = '862'
		AND  ed.EDIStandard = 'LearMexico' 
		AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	SELECT
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		SET	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Update>
END

/*		- 830s.*/
IF	EXISTS
	(	SELECT
			*
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '830'
			AND  ed.EDIStandard = 'LearMexico' 
			AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) BEGIN
	--- <Update rows="*">
	SET	@TableName = 'EDI.EDIDocuments'
	
	UPDATE
		ed
	SET
		Status = 1 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Processed'))
	FROM
		EDI.EDIDocuments ed
	WHERE
		ed.Type = '830'
		AND  ed.EDIStandard = 'LearMexico' 
		AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	SELECT
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		SET	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
	--- </Update>
END
--- </Body>

---	<Return>
set @Result = 0
return
--- </Return>

---	<Error>
queueError:

set @Result = 100
raiserror ('2040 documents already in process.  Use EDILearMexico.usp_ClearQueue to clear the queue if necessary.', 16, 1)
return
--- </Error>

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
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

begin transaction

execute
	@ProcReturn = EDILearMexico.usp_Stage_1
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


Select 'StagingSSHeaders'
select
	*
from
	[MONITOR].EDILearMexico.StagingShipScheduleHeaders sfh

Select 'StagingSSchedules'
select
	*
from
	[MONITOR].EDILearMexico.StagingShipSchedules sfr

Select 'StagingSSAccums'
select 
	*
from
	[MONITOR].EDILearMexico.StagingShipScheduleAccums sfs

Select 'StagingSSSupplemental'
select 
	*
from
	[MONITOR].EDILearMexico.StagingShipScheduleSupplemental sfs
go

Select 'PlanningHeaders'
select
	*
from
	[MONITOR].EDILearMexico.StagingPlanningHeaders sfh

Select 'PlanningReleases'
select
	*
from
	[MONITOR].EDILearMexico.StagingPlanningReleases sfr

Select 'PlanningAccums'	
select 
	*
from
	[MONITOR].EDILearMexico.StagingPlanningAccums sfa
Select 'PlanningAuthAccums'	

select 
	*
from
	[MONITOR].EDILearMexico.StagingPlanningAuthAccums sfa

Select 'PlanningSupplemental'	
select 
	*
from
	[MONITOR].EDILearMexico.StagingPlanningSupplemental sfa



rollback
go

set statistics io off
set statistics time off
go

}

Results {
}
*/




















GO
