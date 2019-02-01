SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIEDIFACT04A].[usp_Stage1_GetPlanningAuthAccums]
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
		@tempPlanningReleaseQuantities1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	Data xml
	)

	declare
		@tempPlanningReleaseQuantities2 table
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
	,	Data xml
	)

	declare
		@tempPlanningReleaseQuantities2a table
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
	,	Data xml
	)

	
declare
		@PlanningReleaseQuantities table
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
	,	QuantityQualifier varchar(50)
	,	Quantity varchar(50)
	,	QuantityType varchar(50)
	,	DateType varchar(50)
	,	DateDT varchar(50)
	,	DateDTFormat varchar(50)
	)


	insert
		@tempPlanningReleaseQuantities1
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode	
	,	Data
	)
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		coalesce(	ed.Data.value('(/TRN-DELFOR/SEG-BGM/CE/DE[@code="1004"])[1]', 'varchar(50)'),'')
	,	ShipToCode =	coalesce(	EDIData.Releases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)')	,ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'))
	,	ConsigneeCode = coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="IC"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)
	,	ShipFromCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SF"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)								
	,	SupplierCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)		
	,	Data = EDIData.Releases.query('.')
	from
		#PlanningHeaders ed
		cross apply ed.Data.nodes('/TRN-DELFOR/LOOP-GEI/LOOP-LIN') as EDIData(Releases)


	insert
		@tempPlanningReleaseQuantities2
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode	
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOline
	,	CustomerECL
	,	CustomerModelYear
	,	Data
	)
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		ed.ReleaseNo
	,	ShipToCode =	ed.ShipToCode
	,	ConsigneeCode = ed.ConsigneeCode
	,	ShipFromCode = ed.ShipFromCode								
	,	SupplierCode = ed.SupplierCode
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerECL =''
	,	CustomerModelYear = ''
	,	Data = EDIData.Releases.query('.')
	from
		@tempPlanningReleaseQuantities1 ed
		cross apply ed.data.nodes('/LOOP-LIN/LOOP-QTY') as EDIData(Releases)


		insert
		@tempPlanningReleaseQuantities2a
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode	
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOline
	,	CustomerECL
	,	CustomerModelYear
	,	Data
	)
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		ed.ReleaseNo
	,	ShipToCode =	ed.ShipToCode
	,	ConsigneeCode = ed.ConsigneeCode
	,	ShipFromCode = ed.ShipFromCode								
	,	SupplierCode = ed.SupplierCode
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerECL =''
	,	CustomerModelYear = ''
	,	Data = EDIData.Releases.query('.')
	from
		@tempPlanningReleaseQuantities1 ed
		cross apply ed.data.nodes('/LOOP-LIN/LOOP-SCC/LOOP-QTY') as EDIData(Releases)


	insert
		@PlanningReleaseQuantities
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
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	UserDefined1	=	''
	,	UserDefined2	=	''
	,	UserDefined3	=	''
	,	UserDefined4	=	''
	,	UserDefined5	=	''
	,	UserDefined6	=	''
	,	UserDefined7	=	''
	,	UserDefined8	=	'LOOP-QTY'
	,	UserDefined9	=	data.value('(/LOOP-QTY/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"])[1]', 'varchar(15)') --RFFTypeQualifier
	,	UserDefined10	=	data.value('(/LOOP-QTY/LOOP-RFF/SEG-RFF/CE/DE[@code="1154"])[1]', 'varchar(15)') --RFF
	,	QuantityQualifier =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6063"])[1]', 'varchar(15)')
	,	Quantity =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6060"])[1]', 'varchar(15)')
	,	QuantityType = coalesce(data.value('(/LOOP-QTY/SEG-SCC/DE[@code="4017"])[1]', 'varchar(15)'),'0')
	,	DateType = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'),data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'))
	,	DateDT = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'))
	,	DateDTFormat = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'))  
	
	from
		@tempPlanningReleaseQuantities2 as TempQuantities
	UNION 

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
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	UserDefined1	=	''
	,	UserDefined2	=	''
	,	UserDefined3	=	''
	,	UserDefined4	=	''
	,	UserDefined5	=	''
	,	UserDefined6	=	''
	,	UserDefined7	=	''
	,	UserDefined8	=	'LOOP-SCC'
	,	UserDefined9	=	data.value('(/LOOP-SCC/SEG-SCC/CE/DE[@code="2013"])[1]', 'varchar(15)') --RFFTypeQualifier
	,	UserDefined10	=	data.value('(/LOOP-SCC/SEG-SCC/CE/DE[@code="2015"])[1]', 'varchar(15)') --RFF
	,	QuantityQualifier =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6063"])[1]', 'varchar(15)')
	,	Quantity =	data.value('(/LOOP-QTY/SEG-QTY/CE/DE[@code="6060"])[1]', 'varchar(15)')
	,	QuantityType = coalesce(data.value('(/SEG-SCC/DE[@code="4017"])[1]', 'varchar(15)'),'0')
	,	DateType = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'),data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'))
	,	DateDT = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'))
	,	DateDTFormat = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'))  
	
	from
		@tempPlanningReleaseQuantities2a as TempQuantities
insert
	#PlanningAuthAccums
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
	,	AuthAccum 
	,	AuthAccumBeginDT 
	,	AuthAccumEndDT 
	,	FabAccum 
	,	FabAccumBeginDT 
	,	FabAccumEndDT 
	,	RawAccum 
	,	RawAccumBeginDT 
	,	RawAccumEndDT 
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
	,	UserDefined6
	,	UserDefined7
	,	UserDefined8
	,	UserDefined9
    ,	userDefined10 
	,   AuthAccum = max(case when QuantityQualifier = '79' then coalesce(nullif(Quantity,''),0) end)
	,   AuthAccumBeginDT = max(case when QuantityQualifier = '79' then case coalesce(DateDTFormat,'') 
					when '102' Then edi.udf_GetDT('CCYYMMDD', DateDT)
					when '103' Then edi.udf_GetDT('CCYYWW', DateDT)
					when '203' Then edi.udf_GetDT('CCYYMMDDHHMM', DateDT)
					when '' Then Null
					else convert (DateTime, DateDT)
					end end)
    ,   AuthAccumEndDT = max(case when QuantityQualifier = '79' then case coalesce(DateDTFormat,'')
					when '102' Then edi.udf_GetDT('CCYYMMDD', DateDT)
					when '103' Then edi.udf_GetDT('CCYYWW', DateDT)
					when '203' Then edi.udf_GetDT('CCYYMMDDHHMM', DateDT)
					when '' Then Null
					else convert (DateTime, DateDT)
					end end)
    ,	FabAccum =''
	,	FabAccumBeginDT =''
	,	FabAccumEndDT =''
	,	RawAccum = ''
	,	RawAccumBeginDT = ''
	,	RawAccumEndDT = ''
   
    
     from
        @PlanningReleaseQuantities
	where
		coalesce(QuantityQualifier,'XX') in ('79') and
		coalesce(UserDefined8,'') in ( 'LOOP-SCC', 'LOOP-QTY')
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
	,	UserDefined6
	,	UserDefined7
	,	UserDefined8
	,	UserDefined9
	,	UserDefined10
	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#PlanningAccums', @toc
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
	@ProcReturn = EDIEDIFACT04A.usp_Stage1_GetPlanningAccums
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
