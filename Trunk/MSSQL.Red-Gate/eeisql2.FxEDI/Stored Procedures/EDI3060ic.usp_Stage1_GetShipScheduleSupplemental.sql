SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDI3060ic].[usp_Stage1_GetShipScheduleSupplemental]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI3060ic.usp_Test
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
	@ShipScheduleSupplementalTemp1 table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(50)
,	ConsigneeCode varchar(50)
,	ShipFromCode varchar(50)
,	SupplierCode varchar(50)	
,	Data xml
)

declare
	@ShipScheduleSupplementalTemp2 table
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
	@ShipScheduleSupplementalTemp3 table
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
,	ValueQualifier varchar(50)
,	Value varchar (50)
)

insert
		@ShipScheduleSupplementalTemp1
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
	From	
		#ShipScheduleHeaders ed
	outer apply ed.Data.nodes('/TRN-862/LOOP-LIN') as EDIData(Releases)
	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp1', @toc
end

insert
		@ShipScheduleSupplementalTemp2
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
	,	CustomerPart = EDIData.Data.value('(	for $a in SEG-LIN/DE[@code="0235"] where $a="BP" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPO = EDIData.Data.value('(	for $a in SEG-LIN/DE[@code="0235"] where $a="PO" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPOLine = EDIData.Data.value('(	for $a in SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerModelYear = ''
	,	CustomerECL = ''
	,	Data = EDIData.Data.query('.')
	
	from
		@ShipScheduleSupplementalTemp1 ed
		outer apply ed.data.nodes('/LOOP-LIN/LOOP-RFF') as EDIData(Data)
	order by
		2
	,	3
	,	7

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp2', @toc
end

Insert
	@ShipScheduleSupplementalTemp3
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
	,	ValueQualifier
	,	Value
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
	,	ValueQualifier	=	Data.value('(/LOOP-RFF/DE[@code="7511"])[1]', 'varchar(50)')	
	,	Value		=	Data.value('(/LOOP-RFF/DE[@code="7102"])[1]', 'varchar(50)')	
	
	from
		@ShipScheduleSupplementalTemp2 ed
	order by
		2
	,	3
	,	7

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp3', @toc
end

insert
	#ShipScheduleSupplemental
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
	,	UserDefined1 = max(case when ValueQualifier = 'DK' then Value end)
	,	UserDefined2 = max(case when ValueQualifier = 'LF' then Value end)
	,	UserDefined3 = max(case when ValueQualifier = 'RL' then Value end)
	,	UserDefined4 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined5 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined6 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined7 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined8 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined9 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined10 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined11 = max(case when ValueQualifier = '11Z' then Value end)
	,	UserDefined12 = max(case when ValueQualifier = '12Z' then Value end)
	,	UserDefined13 = max(case when ValueQualifier = '13Z' then Value end)
	,	UserDefined14 = max(case when ValueQualifier = '14Z' then Value end)
	,	UserDefined15 = max(case when ValueQualifier = '15Z' then Value end)
	,	UserDefined16 = max(case when ValueQualifier = '16Z' then Value end)
	,	UserDefined17 = max(case when ValueQualifier = '17Z' then Value end)
	,	UserDefined18 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined19 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined20 = max(case when ValueQualifier = '??' then Value end)
	from
		@ShipScheduleSupplementalTemp3
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
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#ShipScheduleSupplemental', @toc
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
	@ProcReturn = EDI3060ic.usp_Stage1_GetShipScheduleSupplimental
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
