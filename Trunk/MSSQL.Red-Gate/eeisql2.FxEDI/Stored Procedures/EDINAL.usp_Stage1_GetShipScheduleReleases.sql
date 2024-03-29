SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [EDINAL].[usp_Stage1_GetShipScheduleReleases]
	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDINAL.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
--declare
--	@TranCount smallint

--set	@TranCount = @@TranCount
--if	@TranCount = 0 begin
--	begin tran @ProcName
--end
--else begin
--	save tran @ProcName
--end
--set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
if	@Debug > 0 begin
	declare
		@toc time
end

declare
		@ShipSchedulesTemp1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	Data xml
	)

	declare
		@ShipSchedulesTemp2 table
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
	,	Data xml
	)


	declare
		@ShipSchedulesTemp3 table
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


	insert
		@ShipSchedulesTemp1
	(	RawDocumentGUID
	,	ReleaseNo 
	,	ShipToCode 
	,	ConsigneeCode 
	,	ShipFromCode 
	,	SupplierCode	
	,	Data	
	)

	select
		RawDocumentGUID
	,	ReleaseNo = coalesce(nullif(ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0328"])[1]', 'varchar(30)'),''), ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0127"])[1]', 'varchar(30)')) + '-' + isNULL(ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0373"])[1]', 'varchar(30)'),'')
	,	ShipToCode = coalesce(EDIData.Releases.value('(./SEG-REF [DE[.="DK"][@code="0128"]]/DE[@code="0127"])[1]', 'varchar(50)'), EDIData.Releases.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'), EDIData.Releases.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'))
	,	ConsigneeCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="IC"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	ShipFromCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SF"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	SupplierCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SU"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	Data = EDIData.Releases.query('.')
	from
		#ShipScheduleHeaders ed
		outer apply ed.Data.nodes('/TRN-862/LOOP-LIN') as EDIData(Releases)
	

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleReleasesTemp1', @toc
end
	
	insert
		@ShipSchedulesTemp2
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
	,	Data	
	)
	select
		RawDocumentGUID
	,	ReleaseNo 
	,	ShipToCode 
	,	ConsigneeCode 
	,	ShipFromCode 
	,	SupplierCode	
	,	CustomerPart = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="BP" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPO = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="PO" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPOLine = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerModelYear = ''
	,	CustomerECL = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="EC" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	Data = EDIData.Data.query('.')
	
	from
		@ShipSchedulesTemp1 ed
		cross apply ed.Data.nodes('/LOOP-LIN/LOOP-FST[not(LOOP-JIT)]/SEG-FST') as EDIData(Data)
	order by
		2
	,	3
	,	7

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleReleasesTemp2.1', @toc
end

insert
		@ShipSchedulesTemp2
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
	,	Data	
	)

	select
		RawDocumentGUID
	,	ReleaseNo 
	,	ShipToCode 
	,	ConsigneeCode 
	,	ShipFromCode 
	,	SupplierCode	
	,	CustomerPart = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="BP" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPO = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="PO" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,   CustomerPOLine = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerModelYear = ''
	,	CustomerECL = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="EC" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	Data = EDIData.Data.query('.')
	
	from
		@ShipSchedulesTemp1 ed
		cross apply ed.Data.nodes('/LOOP-LIN/LOOP-FST/LOOP-JIT/SEG-JIT') as EDIData(Data)
	order by
		2
	,	3
	,	7

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleReleasesTemp2.2', @toc
end


		
	insert
		@ShipSchedulesTemp3
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
	,	DateDue
	,	QuantityDue
	,	QuantityType
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
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 = Data.value('(	for $a in SEG-FST/DE[@code="0128"] where $a="DO" return $a/../DE[. >> $a][@code="0127"][1])[1]', 'varchar(30)')
	,	DateDue = Data.value('(/SEG-FST/DE[@code="0373"])[1]', 'varchar(50)')
	,	QuantityDue = Data.value('(/SEG-FST/DE[@code="0380"])[1]', 'varchar(50)')
	,	QuantityType = Data.value('(/SEG-FST/DE[@code="0680"])[1]', 'varchar(50)')
 
	
	from
		@ShipSchedulesTemp2


if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleReleasesTemp3', @toc
end

insert
	#ShipSchedules
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
	,	DateDue 
	,	QuantityDue 
	,	QuantityType 
	)

	SELECT
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
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 
	,	DateDue 
	,	QuantityDue 
	,	QuantityType
	
	FROM
		@ShipSchedulesTemp3

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#ShipSchedules', @toc
end
--- </Body>

---	<CloseTran AutoCommit=Yes>
--if	@TranCount = 0 begin
--	commit tran @ProcName
--end
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
	@ProcReturn = EDINAL.usp_Stage1_GetShipScheduleReleases
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
