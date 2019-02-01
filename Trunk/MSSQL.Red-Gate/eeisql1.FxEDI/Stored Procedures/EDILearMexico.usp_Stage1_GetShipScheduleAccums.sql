SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDILearMexico].[usp_Stage1_GetShipScheduleAccums]
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
		@ShipScheduleAccumsTemp1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	Data xml
	)

	declare
		@ShipScheduleAccumsTemp2 table
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
		@ShipScheduleAccumsTemp3 table
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

insert
	@ShipScheduleAccumsTemp1
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
	select '@ShipScheduleAccumsTemp1', @toc
end

insert
		@ShipScheduleAccumsTemp2
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
	,	CustomerECL = ''
	,	Data = EDIData.Data.query('.')
	
	from
		@ShipScheduleAccumsTemp1 ed
		outer apply ed.data.nodes('/LOOP-LIN/LOOP-SHP') as EDIData(Data)
	order by
		2
	,	3
	,	7

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleAccumsTemp2', @toc
end
			
insert
		@ShipScheduleAccumsTemp3
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
	,	ReceivedAccum
	,	ReceivedAccumBeginDT
	,	ReceivedAccumEndDT 
	,	ReceivedQty 
	,	ReceivedQtyDT 
	,	ReceivedShipper 
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
	,	ReceivedAccum = Data.value('(for $a in LOOP-SHP/SEG-SHP/DE[@code="0673"] where $a="02" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	ReceivedAccumBeginDT = Data.value('(for $a in LOOP-SHP/SEG-SHP/DE[@code="0374"] where $a="051" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	,	ReceivedAccumEndDT = Data.value('(for $a in LOOP-SHP/SEG-SHP/DE[@code="0374"] where $a="052" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	,	ReceivedQty = Data.value('(for $a in LOOP-SHP/SEG-SHP/DE[@code="0673"] where $a="02" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	ReceivedQtyDT = Data.value('(for $a in LOOP-SHP/SEG-SHP/DE[@code="0374"] where $a="050" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	,	ReceivedShipper = Data.value('(for $a in LOOP-SHP/SEG-REF/DE[@code="0128"] where $a="SI" return $a/../DE[. >> $a][@code="0127"][1])[1]', 'varchar(30)') 
	
	from
		@ShipScheduleAccumsTemp2

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleAccumsTemp3', @toc
end

insert
	#ShipScheduleAccums
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
	,	ReceivedAccum
	,	ReceivedAccumBeginDT
	,	ReceivedAccumEndDT 
	,	ReceivedQty 
	,	ReceivedQtyDT 
	,	ReceivedShipper 
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
	,	ReceivedAccum = max(case when ReceivedAccum is not Null then ReceivedAccum end)
	,	ReceivedAccumBeginDT = max(case when ReceivedAccumBeginDT is not Null then ReceivedAccumBeginDT end)
	,	ReceivedAccumEndDT = max(case when ReceivedAccumEndDT is not Null then ReceivedAccumEndDT end)
	,	ReceivedQty = max(case when ReceivedQty is not Null then ReceivedQty end)
	,	ReceivedQtyDT = max(case when ReceivedQtyDT is not Null then ReceivedQtyDT end)
	,	ReceivedShipper = max(case when ReceivedShipper is not Null then ReceivedShipper end) 
	
	from
		@ShipScheduleAccumsTemp3
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
	select '#ShipScheduleAccums', @toc
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
	@ProcReturn = EDILearMexico.usp_Stage1_GetShipScheduleAccums
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
