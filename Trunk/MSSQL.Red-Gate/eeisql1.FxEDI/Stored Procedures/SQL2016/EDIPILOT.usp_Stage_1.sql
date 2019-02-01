SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


alter procedure [EDIPILOT].[usp_Stage_1]
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
			ed.Type = '210'
			AND  ed.TradingPartner = 'PILOT'
			AND ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) BEGIN
	GOTO queueError
END

/*	Move new and reprocessed 4010 862s and 830s to Staging. */
/*		Set new and requeued documents to in process.*/

--- <Update rows="*">
set	@TableName = 'EDI.EDIDocuments'

if	exists
	(	select
			1
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '210'
			and  ed.TradingPartner = 'PILOT'
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
		ed.Type = '210'
		and  ed.TradingPartner = 'PILOT'
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
				ed.Type = '210'
				and  ed.TradingPartner = 'PILOT'
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
/*		- prepare 210 Invoices...*/

if	exists
	(	select
			*
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '210'
			and  ed.TradingPartner = 'PILOT'
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) 
	BEGIN
/*			- prepare 210 Headers.*/
	create table
		#210Headers
	(	RawDocumentGUID uniqueidentifier
    ,	Data xml
	,	DocumentImportDT datetime
	,	TradingPartner varchar(50)
	,	DocType varchar(6)
	,	Version varchar(20)
	,	DocumentDT datetime
	,	RowID int not null identity(1, 1) primary key
	)

	create primary xml index ix1 on #210Headers (Data)
	create xml index ix2 on #210Headers (Data) using xml index ix1 for path
	--create xml index ix3 on #210Headers (Data) using xml index ix1 for value
	--create xml index ix4 on #210Headers (Data) using xml index ix1 for property

	insert
		#210Headers
	(	RawDocumentGUID
    ,	Data
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	DocumentDT
	)
	select
		RawDocumentGUID = ed.GUID
	,	Data = ed.Data
	,	DocumentImportDT = ed.RowCreateDT
	,	TradingPartner
	,	DocType = ed.Type
	,	Version
	,	DocumentDT = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0373"])[1]', 'datetime')
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '210'
		and ed.TradingPartner = 'PILOT'
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	if	@Debug > 0 begin
		set	@toc = getdate() - @TranDT
		select '#210Headers', @toc

		select
			*
		from
			#210Headers ph
	end

/*			- prepare 210 Headers */
	create table
		#210InvoiceHeader
	(	RawDocumentGUID uniqueidentifier
	,	b3ShipmentQualifier varchar(50)
	,	b3InvoiceNumber varchar(50)
	,	b3ShipperID varchar(50)
	,	b3MethodOfPayment varchar(50)	
	,	b3WeightUnit varchar(50)
	,	b3InvoiceDate varchar(50)
	,	b3NetAmoutDue varchar(50)
	,	b3CorrectionIndicator varchar(50)
	,	b3DeliveryDate varchar(50)	
	,	b3DateTimeQualifier varchar(50) 
	,	b3SCAC varchar(50) 
	,	c3Currency varchar(50)
	,	r3SCAC varchar(50) 
	,	r3RoutingSequence varchar(50) 
	,	r3City varchar(50) 
	,	r3TransMode varchar(50)
	,	r3StdPointLocationCode varchar(50)
	,	r3InvoiceNumber varchar(50)
	,	r3InvoiceDate varchar(50)
	,	r3InvoiceAmount varchar(50)
	,	r3Description varchar(50)
	,	r3ServiceLevelCode varchar(50)
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50) 
	,	UserDefined5 varchar(50) 
	,	UserDefined6 varchar(50) 
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDIPILOT.usp_Stage1_GetInvoiceHeader'
	execute
		@ProcReturn = EDIPILOT.usp_Stage1_GetInvoiceHeaders
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
		select 'EDIPILOT.usp_Stage1_GetInvoiceHeaders', @toc

		select
			*
		from
			#210InvoiceHeader
	end

/*			- prepare 210 REF */
	create table
		#210InvoiceN9REF
	(	RawDocumentGUID uniqueidentifier
	,	b3InvoiceNumber varchar(50)
	,	N9IDQualifier varchar(50)
	,	N9ID varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50) 
	,	UserDefined5 varchar(50) 
	,	UserDefined6 varchar(50) 
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDIPILOT.usp_Stage1_GetInvoiceN9REF'
	execute
		@ProcReturn = EDIPILOT.usp_Stage1_GetInvoiceN9REF
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
		select 'EDIPILOT.usp_Stage1_GetInvoiceN9REF', @toc

		select
			*
		from
			#210InvoiceN9REF
	end




	/*			- prepare 210 Address */
	create table
		#210InvoiceAddress
	(	[RawDocumentGUID] [uniqueidentifier] NULL,
		[InvoiceNumber] [varchar](25) NULL,
	[N1Qualifier] [varchar](50) NULL,
	[N1Name] [varchar](50) NULL,
	[N1IDQualifier] [varchar](50) NULL,
	[N1IDCode] [varchar](50) NULL,
	[N201Name] [varchar](50) NULL,
	[N202Name] [varchar](50) NULL,
	[N301Address] [varchar](255) NULL,
	[N401City] [varchar](50) NULL,
	[N402State] [varchar](50) NULL,
	[N403Zip] [varchar](50) NULL,
	[n404Country] [varchar](50) NULL,
	[UserDefined1] [varchar](50) NULL,
	[UserDefined2] [varchar](50) NULL,
	[UserDefined3] [varchar](50) NULL,
	[UserDefined4] [varchar](50) NULL,
	[UserDefined5] [varchar](50) NULL,
	[UserDefined6] [varchar](50) NULL,
	[UserDefined7] [varchar](50) NULL,
	[UserDefined8] [varchar](50) NULL,
	[UserDefined9] [varchar](50) NULL,
	[UserDefined10] [varchar](50) NULL
	)

	--- <Call>	
	set	@CallProcName = 'EDIPILOT.usp_Stage1_GetInvoiceHeader'
	execute
		@ProcReturn = EDIPILOT.usp_Stage1_GetInvoiceAddress
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
		select 'EDIPILOT.usp_Stage1_GetInvoiceHeaders', @toc

		select
			*
		from
			#210InvoiceHeader
	end


	/*			- prepare 210 Detail */
	create table
		#210InvoiceDetail
	(	RawDocumentGUID uniqueidentifier
	,	InvoiceNumber	varchar(25)
	,	b3lXAssignedNumber varchar(50)
	,	n9Qualifier varchar(50)
	,	n9Data varchar(50)
	,	podDate varchar(50)
	,	podTime varchar(50)
	,	podName varchar(50)
	,	l5LadingLineItemNumber varchar(50)
	,	l5LadingDescription varchar(50)	
	,	L0LadinglineItemNumber varchar(50) 
	,	l0BilledQty varchar(50) 
	,	l0BilledQtyUOM varchar(50)
	,	l0WeightQualfier varchar(50) 
	,	l0Volume varchar(50) 
	,	l0VolumeUnit varchar(50) 
	,	l0LadingQty varchar(50)
	,	l0PackagingCode varchar(50)
	,	l1ladingLineItem varchar(50)
	,	l1FreightRate varchar(50)
	,	l1RateQualifier varchar(50)
	,	l1RateCharge varchar(50)
	,	L4Length varchar(50)
	,	L4Width varchar(50)
	,	L4Height varchar(50) 
	,	L4UOM varchar(50) 
	,	L4Qty varchar(50)  
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50) 
	,	UserDefined5 varchar(50) 
	,	UserDefined6 varchar(50) 
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDIPILOT.usp_Stage1_GetInvoiceDetail'
	execute
		@ProcReturn = EDIPILOT.usp_Stage1_GetInvoiceDetail
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
		select 'EDIPILOT.usp_Stage1_GetInvoiceDetail', @toc

		select
			*
		from
			#210InvoiceHeader
	end


	/*			- prepare 210 Summary */
	create table
		#210InvoiceSummary
	(	RawDocumentGUID uniqueidentifier
	,	b3InvoiceNumber varchar(50)
	,	l3Weight varchar(50)
	,	l3WeightQualifier varchar(50)	
	,	l3FreightWeight varchar(50)
	,	l3rateQualifier varchar(50)
	,	l3Charge varchar(50)
	,	l3Advances varchar(50)
	,	l3PrepaidAmount varchar(50)	
	,	l3SAC varchar(50) 
	,	l3Volume varchar(50) 
	,	l3VolumneQual varchar(50)
	,	l3ladingQty varchar(50) 
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50) 
	,	UserDefined5 varchar(50) 
	,	UserDefined6 varchar(50) 
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	)

	--- <Call>	
	set	@CallProcName = 'EDIPILOT.usp_Stage1_GetInvoiceHeader'
	execute
		@ProcReturn = EDIPILOT.usp_Stage1_GetInvoiceSummary
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
		select 'EDIPILOT.usp_Stage1_GetInvoiceSummary', @toc

		select
			*
		from
			#210InvoiceHeader
	end

END


----------------------------------------------------------------------------------------------------------

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#210Headers')
) begin

	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceHeader')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingDoc210Headers'

	insert
		[MONITOR].EDIPILOT.StagingInvoice210Docs
	(	RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	DocumentDT
	)
	select
		RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	DocumentDT
	from
		#210Headers fh

	select
		@Error = @@Error
	,	@RowCount = @@Rowcount

	if	@Error != 0 begin
		set @Result = 999999
		raiserror ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
END
END
/*			- write 210 Headers.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceHeader')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingInvoice210Headers'
	
	insert 
		[MONITOR].EDIPILOT.StagingInvoice210Headers
	(	RawDocumentGUID 
	,	b3ShipmentQualifier 
	,	b3InvoiceNumber 
	,	b3ShipperID 
	,	b3MethodOfPayment 	
	,	b3WeightUnit
	,	b3InvoiceDate
	,	b3NetAmoutDue 
	,	b3CorrectionIndicator 
	,	b3DeliveryDate	
	,	b3DateTimeQualifier  
	,	b3SCAC 
	,	c3Currency 
	,	r3SCAC  
	,	r3RoutingSequence  
	,	r3City 
	,	r3TransMode
	,	r3StdPointLocationCode 
	,	r3InvoiceNumber 
	,	r3InvoiceDate
	,	r3InvoiceAmount
	,	r3Description 
	,	r3ServiceLevelCode 
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
    )
    
	select
		RawDocumentGUID 
	,	b3ShipmentQualifier 
	,	b3InvoiceNumber 
	,	b3ShipperID 
	,	b3MethodOfPayment 	
	,	b3WeightUnit
	,	b3InvoiceDate
	,	convert( numeric(20,6), coalesce(nullif(b3NetAmoutDue,''),'0'))
	,	b3CorrectionIndicator 
	,	convert(datetime,b3DeliveryDate)
	,	b3DateTimeQualifier  
	,	b3SCAC 
	,	c3Currency 
	,	r3SCAC  
	,	r3RoutingSequence  
	,	r3City 
	,	r3TransMode
	,	r3StdPointLocationCode 
	,	r3InvoiceNumber 
	,	convert(datetime, r3InvoiceDate )
	,	convert( numeric(20,6), coalesce(nullif(r3InvoiceAmount,''),'0'))
	,	r3Description 
	,	r3ServiceLevelCode 
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
   from
       #210InvoiceHeader

 

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END

	END
	--- </Insert>

	/*			- write 210 REF.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceN9REF')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingInvoice210N9REF'
	
	insert 
		[MONITOR].EDIPILOT.StagingInvoice210N9REF
	(	RawDocumentGUID  
	,	b3InvoiceNumber 
	,	N9IDQualifier 
	,	N9ID 	
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
    )
    
	select
		RawDocumentGUID 
	,	b3InvoiceNumber 
	,	N9IDQualifier 
	,	N9ID 	
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
   from
       #210InvoiceN9REF

 

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END

	END
	--- </Insert>

	/*			- write 210 Address.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceAddress')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingInvoice210Address'
	
	INSERT [MONITOR].[EDIPILOT].[StagingInvoice210Address]
           (
            [RawDocumentGUID]
           ,[InvoiceNumber]
           ,[N1Qualifier]
           ,[N1Name]
           ,[N1IDQualifier]
           ,[N1IDCode]
           ,[N201Name]
           ,[N202Name]
           ,[N301Address]
           ,[N401City]
           ,[N402State]
           ,[N403Zip]
           ,[n404Country]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
		)
    
	select
			[RawDocumentGUID]
           ,[InvoiceNumber]
           ,[N1Qualifier]
           ,[N1Name]
           ,[N1IDQualifier]
           ,[N1IDCode]
           ,[N201Name]
           ,[N202Name]
           ,[N301Address]
           ,[N401City]
           ,[N402State]
           ,[N403Zip]
           ,[n404Country]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
   from
       #210InvoiceAddress

 

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END

	END
	--- </Insert>



/*			- write 210 Details.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceDetail')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingInvoice210Detail'
	
	insert 
		[MONITOR].EDIPILOT.StagingInvoice210Detail
	(	RawDocumentGUID
	,	InvoiceNumber
	,	b3lXAssignedNumber
	,	n9Qualifier
	,	n9Data  	
	,	podDate 
	,	podTime 
	,	podName 
	,	l5LadingLineItemNumber 
	,	l5LadingDescription 	
	,	L0LadinglineItemNumber  
	,	l0BilledQty  
	,	l0BilledQtyUOM 
	,	l0WeightQualfier 
	,	l0Volume  
	,	l0VolumeUnit 
	,	l0LadingQty 
	,	l0PackagingCode 
	,	l1ladingLineItem 
	,	l1FreightRate 
	,	l1RateQualifier 
	,	l1RateCharge 
	,	L4Length 
	,	L4Width 
	,	L4Height  
	,	L4UOM  
	,	L4Qty   
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
    )
    
	select 
		RawDocumentGUID
	,	InvoiceNumber
	,	b3lXAssignedNumber
	,	n9Qualifier
	,	n9Data  	
	,	podDate 
	,	podTime 
	,	podName 
	,	l5LadingLineItemNumber 
	,	l5LadingDescription 	
	,	L0LadinglineItemNumber  
	,	convert( numeric(20,6), nullif(l0BilledQty,'') )  
	,	l0BilledQtyUOM 
	,	l0WeightQualfier 
	,	convert( numeric (20,6), nullif(l0Volume,'')  )
	,	l0VolumeUnit 
	,	convert( numeric (20,6), nullif(l0LadingQty,'') )
	,	l0PackagingCode 
	,	l1ladingLineItem 
	,	convert ( numeric (20,6), nullif(l1FreightRate,'') )
	,	l1RateQualifier 
	,	convert ( numeric (20,6), nullif(l1RateCharge,'') )
	,	convert ( numeric (20,6), nullif(L4Length,'') )
	,	convert ( numeric(20,6) , nullif(L4Width,'') )
	,	convert ( numeric(20,6), nullif(L4Height,'') ) 
	,	L4UOM  
	,	convert ( numeric (20,6), nullif(L4Qty,'')  ) 
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
   from
       #210InvoiceDetail

 

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
END	-- </Insert>

/*			- write 210 Summary.*/
	if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

	and o.id = object_id(N'tempdb..#210InvoiceSummary')
)	begin
	--- <Insert rows="*">
	set	@TableName = '[MONITOR].EDIPILOT.StagingInvoice210Summary'
	
	insert 
		[MONITOR].EDIPILOT.StagingInvoice210Summary
	(	[RawDocumentGUID] ,
	[b3InvoiceNumber],
	[l3Weight] ,
	[l3WeightQualifier] ,
	[l3FreightWeight] ,
	[l3rateQualifier] ,
	[l3Charge] ,
	[l3Advances] ,
	[l3PrepaidAmount] ,
	[l3SAC] ,
	[l3Volume] ,
	[l3VolumneQual] ,
	[l3ladingQty] ,
	[UserDefined1] ,
	[UserDefined2] ,
	[UserDefined3] ,
	[UserDefined4] ,
	[UserDefined5] ,
	[UserDefined6] ,
	[UserDefined7] ,
	[UserDefined8] ,
	[UserDefined9] ,
	[UserDefined10] 
    )
    
	select 
	[RawDocumentGUID] ,
	[b3InvoiceNumber],
	nullif([l3Weight],'') ,
	[l3WeightQualifier] ,
	nullif([l3FreightWeight],'') ,
	[l3rateQualifier] ,
	nullif([l3Charge],'') ,
	[l3Advances] ,
	nullif([l3PrepaidAmount],'') ,
	nullif([l3SAC],'') ,
	nullif([l3Volume],'') ,
	[l3VolumneQual] ,
	nullif([l3ladingQty],'') ,
	[UserDefined1] ,
	[UserDefined2] ,
	[UserDefined3] ,
	[UserDefined4] ,
	[UserDefined5] ,
	[UserDefined6] ,
	[UserDefined7] ,
	[UserDefined8] ,
	[UserDefined9] ,
	[UserDefined10] 
   from
       #210InvoiceSummary

 

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	IF	@Error != 0 BEGIN
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		RETURN
	END
END	-- </Insert>




/*		- 2100s.*/
IF	EXISTS
	(	SELECT
			*
		FROM
			EDI.EDIDocuments ed
		WHERE
			ed.Type = '210'
			AND  ed.TradingPartner = 'PILOT'
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
		ed.Type = '210'
		AND  ed.TradingPartner = 'PILOT'
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
raiserror ('PILOT 210 documents already in process.  Use EDIPILOT.usp_ClearQueue to clear the queue if necessary.', 16, 1)
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
	@ProcReturn = EDIPILOT.usp_Stage_1
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


Select 'Staging210Docs'
select
	*
from
	[MONITOR].EDIPILOT.StagingInvoice210Docs sfh

Select 'Staging210Headers'
select
	*
from
	[MONITOR].EDIPILOT.StagingInvoice210Headers sfr




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
