SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EDIEDIFACT04A].[usp_Stage1_GetPlanningReleases]
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
		@tempPlanningReleaseQuantities_LIN table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	CustomerPOHeader varchar(30)
	,	Data xml
	)

	declare
		@tempPlanningReleaseQuantities_LIN_QTY table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	CustomerPOHeader varchar(30)
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)		
	,	Data xml
	)


	declare
		@PlanningRelease_QTY_Detail table
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

	declare
		@tempPlanningRelease_LIN_SCC table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	CustomerPOHeader varchar(30)
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	SCCQual varchar(50)		
	,	Data xml
	)


	declare
		@tempPlanningRelease_LIN_SCC_QTY table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)
	,	CustomerPOHeader varchar(30)
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)
	,	SCCQual varchar(50)		
	,	Data xml
	)

	declare
		@PlanningRelease_SCC_Detail table
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

	
--declare
--		@PlanningReleaseQuantities table
--	(	RawDocumentGUID uniqueidentifier
--	,	ReleaseNo varchar(50)
--	,	ShipToCode varchar(15)
--	,	ConsigneeCode varchar(15)
--	,	ShipFromCode varchar(15)
--	,	SupplierCode varchar(15)	
--	,	CustomerPart varchar(50)
--	,	CustomerPO varchar(50)
--	,	CustomerPOLine varchar(50)
--	,	CustomerModelYear varchar(50)
--	,	CustomerECL varchar(50)	
--	,	UserDefined1 varchar(50)
--	,	UserDefined2 varchar(50)
--	,	UserDefined3 varchar(50)
--	,	UserDefined4 varchar(50)
--	,	UserDefined5 varchar(50)
--	,	UserDefined6 varchar(50)
--	,	UserDefined7 varchar(50)
--	,	UserDefined8 varchar(50)
--	,	UserDefined9 varchar(50)
--	,	UserDefined10 varchar(50)
--	,	QuantityQualifier varchar(50)
--	,	Quantity varchar(50)
--	,	QuantityType varchar(50)
--	,	DateType varchar(50)
--	,	DateDT varchar(50)
--	,	DateDTFormat varchar(50)
--	)


	insert
		@tempPlanningReleaseQuantities_LIN
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode	
	,   CustomerPOHeader
	,	Data
	)
select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		coalesce(	ed.Data.value('(/TRN-DELFOR/SEG-BGM/CE/DE[@code="1004"])[1]', 'varchar(50)'),'')
	,	ShipToCode =	coalesce(	EDIData.Releases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)')	,ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="BY"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'))
	,	ConsigneeCode = coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="IC"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)
	,	ShipFromCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SE"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'), ''	)								
	,	SupplierCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SE"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'), ''	)	
	,	CustomerPOHeader =  coalesce(	ed.Data.value('(for $a in /TRN-DELFOR/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)'),''	)		
	,	Data = EDIData.Releases.query('.')
	from
		#PlanningHeaders ed
		cross apply ed.Data.nodes('/TRN-DELFOR/LOOP-GEI/LOOP-LIN') as EDIData(Releases)



	insert
		@tempPlanningReleaseQuantities_LIN_QTY
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
	,	ShipFromCode =	ed.ShipFromCode								
	,	SupplierCode =	ed.SupplierCode
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) ,  (Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')),  CustomerPOHeader    )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerECL =''
	,	CustomerModelYear = ''
	,	Data = EDIData.Releases.query('.')
	from
		@tempPlanningReleaseQuantities_LIN ed
		cross apply ed.data.nodes('/LOOP-LIN/LOOP-QTY') as EDIData(Releases)

	insert
		@PlanningRelease_QTY_Detail
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
		@tempPlanningReleaseQuantities_LIN_QTY as TempQuantities


	insert
		@tempPlanningRelease_LIN_SCC
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
	,	SCCQual
	,	Data
	)
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		ed.ReleaseNo
	,	ShipToCode =	ed.ShipToCode
	,	ConsigneeCode = ed.ConsigneeCode
	,	ShipFromCode =	ed.ShipFromCode								
	,	SupplierCode =	ed.SupplierCode
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) ,  (Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')),  CustomerPOHeader    )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerECL =''
	,	CustomerModelYear = ''
	,	SCCQual = ''
	,	Data = EDIData.Releases.query('.')
	from
		@tempPlanningReleaseQuantities_LIN ed
		cross apply ed.data.nodes('/LOOP-LIN/LOOP-SCC') as EDIData(Releases)


		insert
		@tempPlanningRelease_LIN_SCC_QTY
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
	,	SCCQual
	,	Data
	)
	select
		RawDocumentGUID = ed.RawDocumentGUID
	,	ReleaseNo =		ed.ReleaseNo
	,	ShipToCode =	ed.ShipToCode
	,	ConsigneeCode = ed.ConsigneeCode
	,	ShipFromCode = ed.ShipFromCode								
	,	SupplierCode = ed.SupplierCode
	,	CustomerPart	=	ed.CustomerPart
	,	CustomerPO		=	ed.customerPO
	,	CustomerPOLine	=	ed.CustomerPOLine
	,	CustomerECL =''
	,	CustomerModelYear = ''
	,	SCCQual = ed.Data.value('(/LOOP-SCC/SEG-SCC/DE[@code="4017"])[1]', 'varchar(15)')
	,	Data = EDIData.Releases.query('.')
	from
		@tempPlanningRelease_LIN_SCC ed
		cross apply ed.data.nodes('/LOOP-SCC/LOOP-QTY') as EDIData(Releases)
		
	insert
		@PlanningRelease_SCC_Detail
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
	,	ReleaseNo + CASE	WHEN  SCCQual = '1' THEN ':'+'Firm'
							WHEN  SCCQual = '4' THEN ':'+'Plan'
							ELSE '' END 
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
	,	QuantityType = SCCQual
	,	DateType = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'),data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2005"])[1]', 'varchar(15)'))
	,	DateDT = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2380"])[1]', 'varchar(15)'))
	,	DateDTFormat = coalesce(data.value('(/LOOP-QTY/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'), data.value('(/LOOP-QTY/LOOP-RFF/SEG-DTM/CE/DE[@code="2379"])[1]', 'varchar(15)'))  
	
	from
		@tempPlanningRelease_LIN_SCC_QTY as TempQuantities

Insert #PlanningReleases
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
	,	DateDue = CASE DateDTFormat 
					WHEN '102' THEN edi.udf_GetDT('CCYYMMDD', DateDT)
					WHEN '103' THEN edi.udf_GetDT('CCYYWW', DateDT)
					WHEN '203' THEN edi.udf_GetDT('CCYYMMDDHHMM', DateDT)
					ELSE CONVERT (DATETIME, DateDT)
					END	
	,	QuantityDue =  Quantity
	,	QuantityType = QuantityType
	FROM
		@PlanningRelease_SCC_Detail
	WHERE
		QuantityType NOT IN( '2','3')
    Union									--Get back ordered quantities
	select
        RawDocumentGUID
	,	ReleaseNo+':BackOrd'
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
	,	'LOOP-SCC'
	,	UserDefined9
    ,	userDefined10 
	,	DateDue = getdate()
	,	QuantityDue =  Quantity
	,	QuantityType = 1
	FROM
		@PlanningRelease_QTY_Detail
	WHERE
		QuantityQualifier IN( '83')
		order by 7 , 22
		--set back order quantity due date one day prior to 1st due date
		update PR 
		Set PR.DateDue = (select  dateadd(dd,-1, min(convert(datetime ,dateDue))) from #PlanningReleases PR2 where Pr2.RawDocumentGUID = pr.RawDocumentGUID and  PR2.CustomerPart = pR.customerpart and pr2.ShipToCode = pr.ShipToCode and pr2.CustomerPO = pr.CustomerPO and pr2.ReleaseNo not like '%BackOrd%' )
		From #PlanningReleases PR
		where PR.ReleaseNo like '%BackOrd%'
    --
	--Select * From @tempPlanningReleaseQuantities_LIN
	--Select * From @tempPlanningReleaseQuantities_LIN_QTY
	--Select * From @PlanningRelease_QTY_Detail
	--Select * From @tempPlanningRelease_LIN_SCC
	--Select * from @tempPlanningRelease_LIN_SCC_QTY
	--Select * From @PlanningRelease_SCC_Detail
    
    

	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#PlanningReleases', @toc
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
