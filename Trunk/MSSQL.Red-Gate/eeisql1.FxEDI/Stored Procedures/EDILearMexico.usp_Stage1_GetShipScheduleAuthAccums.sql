SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDILearMexico].[usp_Stage1_GetShipScheduleAuthAccums]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILearMexico.usp_Test
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
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
if	@Debug > 0 begin
	declare
		@toc time
end

declare
		@ShipScheduleAuthAccumsTemp1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	Data xml
	)

	declare
		@ShipScheduleAuthAccumsTemp2 table
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
		@ShipScheduleAuthAccumsTemp3 table
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
insert
	@ShipScheduleAuthAccumsTemp1
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
	,	ShipToCode = coalesce(nullif(EDIData.Releases.value('(./SEG-REF [DE[.="DK"][@code="0128"]]/DE[@code="0127"])[1]', 'varchar(50)'),''), nullif(EDIData.Releases.value('(./LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),''), nullif(EDIData.Releases.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),''),ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'), '')
	,	ConsigneeCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="IC"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	ShipFromCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SF"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	SupplierCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SU"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	Data = EDIData.Releases.query('.')
	from
		#ShipScheduleHeaders ed
		outer apply ed.Data.nodes('/TRN-862/LOOP-LIN') as EDIData(Releases)

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleAuthAccumsTemp1', @toc
end

insert
		@ShipScheduleAuthAccumsTemp2
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
	, CustomerPOLine = ed.Data.value('(	for $a in LOOP-LIN/SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerModelYear = ''
	,	CustomerECL = ''
	,	Data = EDIData.Data.query('.')
	
	from
		@ShipScheduleAuthAccumsTemp1 ed
		cross apply ed.data.nodes('/LOOP-LIN/LOOP-ATH') as EDIData(Data)
	order by
		2
	,	3
	,	7


if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleAuthAccumsTemp2', @toc
end

insert
		@ShipScheduleAuthAccumsTemp3
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
	,	AuthAccum
	,	AuthAccumBeginDT
	,	AuthAccumEndDT 
 
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
	,	UserDefined5 = ''
	,	AuthAccum = Data.value('(for $a in LOOP-ATH/SEG-ATH/DE[@code="0673"] where $a="02" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	AuthAccumBeginDT = Data.value('(for $a in LOOP-ATH/SEG-ATH/DE[@code="0374"] where $a="051" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	,	AuthAccumEndDT = Data.value('(for $a in LOOP-ATH/SEG-ATH/DE[@code="0374"] where $a="052" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)') 
	
	from
		@ShipScheduleAuthAccumsTemp2


if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleAuthAccumsTemp3', @toc
end

insert 
	#ShipScheduleAuthAccums
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
	,	AuthAccum
	,	AuthAccumBeginDT
	,	AuthAccumEndDT 
 
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
	,	UserDefined5 = ''
	,	AuthAccum = max(case when AuthAccum is not Null then AuthAccum end)
	,	AuthAccumBeginDT = max(case when AuthAccumBeginDT is not Null then AuthAccumBeginDT end)
	,	AuthAccumEndDT = max(case when AuthAccumEndDT is not Null then AuthAccumEndDT end)

	from
		@ShipScheduleAuthAccumsTemp3
group by
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
	 

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#ShipScheduleAuthAccums', @toc
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
	@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleAuthAccums
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
