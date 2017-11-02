SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE procedure [EDIEDIFACT04A].[usp_Stage1_GetShipScheduleReleases]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIEDIFACT04A.usp_Test
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

		@ShipScheduleQuantities table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)	
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
	,	UserDefined6 varchar(50)
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	,	SEQQualifier varchar(50)
	,	QuantityQualifier varchar(50)
	,	Quantity varchar(50)
	,	QuantityType varchar(50)
	,	DateType varchar(50)
	,	DateDT varchar(50)
	,	DateDTFormat varchar(50)
	)

	Declare	@tempShipScheduleQuantities table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	HeaderDeliveryDate varchar(15)
	,	SEQData xml	
	,	LINData xml
	,	Data xml
	)

	insert
		@tempShipScheduleQuantities
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	HeaderDeliveryDate
	,	SEQData
	,	LINData
	,	Data
	)
	
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		coalesce(	ed.Data.value('(/TRN-DELJIT/SEG-BGM[1]/CE/DE[@code="1004"])[1]', 'varchar(50)'),'')
	,	ShipToCode =	coalesce(	EDIData.Releases.value('(../SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)')	,ed.Data.value('(/TRN-DELJIT/LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'))
	,	ConsigneeCode = coalesce(	ed.Data.value('(/TRN-DELJIT/LOOP-NAD/SEG-NAD [DE[.="IC"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)
	,	ShipFromCode =  coalesce(	ed.Data.value('(/TRN-DELJIT/LOOP-NAD/SEG-NAD [DE[.="SF"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)								
	,	SupplierCode =  coalesce(	ed.Data.value('(/TRN-DELJIT/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)
	, HeaderDeliveryDate = ed.Data.value('(/TRN-DELJIT/SEG-DTM/CE/DE[@code="2380"])[2]', 'varchar(15)')
	,	SEQData = EDIData.Releases.query('../../../LOOP-SEQ')		
	,	LINData = EDIData.Releases.query('../../LOOP-LIN')
	,	Data = EDIData.Releases.query('.')
	from
		#ShipScheduleHeaders ed
		outer apply ed.Data.nodes('/TRN-DELJIT/LOOP-SEQ/LOOP-LIN/LOOP-QTY') as EDIData(Releases)
	

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleReleasesTemp1', @toc
end

insert
		@ShipScheduleQuantities
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
	,	SEQQualifier 
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
	,	CustomerPart	=	coalesce(nullif((LinData.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (LinData.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((LinData.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(LinData.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	LINData.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1156"][1])[1]', 'varchar(50)')
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	UserDefined1	=	''
	,	UserDefined2	=	''
	,	UserDefined3	=	''
	,	UserDefined4	=	''
	,	UserDefined5	=	''
	,	UserDefined6	=	''
	,	UserDefined7	=	''
	,	UserDefined8	=	''
	,	UserDefined9	=	data.value('(/LOOP-QTY/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"])[1]', 'varchar(15)') --RFFTypeQualifier
	,	UserDefined10	=	data.value('(/LOOP-QTY/LOOP-RFF/SEG-RFF/CE/DE[@code="1154"])[1]', 'varchar(15)') --RFF
	,	SEQQualifier	=	SEQdata.value('(/LOOP-SEQ/SEG-SEQ/DE[@code="1229"])[1]', 'varchar(15)')
	,	QuantityQualifier =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6063"])[1]', 'varchar(15)')
	,	Quantity =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6060"])[1]', 'varchar(15)')
	,	QuantityType = coalesce(data.value('(/LOOP-QTY/SEG-SCC/DE[@code="4017"])[1]', 'varchar(15)'),'0')
	,	DateType = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'),data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'))
	,	DateDT = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'), TempQuantities.HeaderDeliveryDate )
	,	DateDTFormat = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)') , data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'),'203')
	
	from
		@tempShipScheduleQuantities as TempQuantities
		
	if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipSchedulequantities', @toc
end
	


insert
	#ShipSchedules
(		RawDocumentGUID
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
	,	QuantityType
	,	QuantityDue  
	,	DateDue 


	)
Select
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
	,	UserDefined6
	,	UserDefined7
	,	UserDefined8
	,	UserDefined9
	,	UserDefined10 
	,	QuantityType
	,	ReleaseQty = convert(numeric(20,6),nullif(Quantity,''))
	,	ReleaseDT = case DateDTFormat 
					when '102' Then edi.udf_GetDT('CCYYMMDD', DateDT)
					when '103' Then edi.udf_GetDT('CCYYWW', DateDT)
					when '203' Then edi.udf_GetDT('CCYYMMDDHHMM', DateDT)
					else convert (DateTime, DateDT)
					end
					
	from
		@ShipScheduleQuantities
	where
		QuantityQualifier in ('1')


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
	@ProcReturn = EDIEDIFACT04A.usp_Stage1_GetShipScheduleReleases
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
