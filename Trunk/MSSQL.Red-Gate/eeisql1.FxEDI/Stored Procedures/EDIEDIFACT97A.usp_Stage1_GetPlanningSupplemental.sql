SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIEDIFACT97A].[usp_Stage1_GetPlanningSupplemental]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIEDIFACT97A.usp_Test
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
		@PlanningReleaseSupplementalTemp table
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
	,	ReferenceType varchar(50)
	,	Reference varchar(50)
	)

	declare
		@tempPlanningReleaseSupplemental1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)		
	,	Data xml
	)

	declare
		@tempPlanningReleaseSupplemental2 table
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

	insert
		@tempPlanningReleaseSupplemental1
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
	,	ShipToCode =	coalesce(	EDIData.Releases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'), EDIData.Releases.value('(../LOOP-NAD/SEG-NAD [DE[.="DP"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)')	,ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="BY"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'))
	,	ConsigneeCode = coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="IC"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)
	,	ShipFromCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SF"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)								
	,	SupplierCode =  coalesce(	ed.Data.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(15)'),''	)		
	,	Data = EDIData.Releases.query('.')
	from
		#PlanningHeaders ed
		cross apply ed.Data.nodes('/TRN-DELFOR/LOOP-GIS/LOOP-LIN') as EDIData(Releases)
	
	
	insert
		@tempPlanningReleaseSupplemental2
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
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	Data = EDIData.ps.query('.')
	
	from
		@tempPlanningReleaseSupplemental1 as ps
		cross apply ps.data.nodes('/LOOP-LIN/SEG-LOC') as EDIData(ps)
	order by
		2
	,	3
	,	8
		

	Insert
		@PlanningReleaseSupplementalTemp
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
	,	ReferenceType
	,	Reference 
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
	,	ReferenceType = data.value('(/SEG-LOC/DE[@code="3227"])[1]', 'varchar(15)')
	,	Reference = data.value('(/SEG-LOC/CE/DE[@code="3225"])[1]', 'varchar(15)')
	From
		@tempPlanningReleaseSupplemental2 ps2
	
	 

	 insert
	#PlanningSupplemental
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
	,	UserDefined1 = max(case when ssst.ReferenceType = 'DK' then ssst.Reference end)
	,	UserDefined2 = max(case when ssst.ReferenceType = 'LF' then ssst.Reference end)
	,	UserDefined3 = max(case when ssst.ReferenceType = 'RL' then ssst.Reference end)
	,	UserDefined4 = max(case when ssst.ReferenceType = '11' then ssst.Reference end)--Qualifier Type of 11
	,	UserDefined5 = max(case when ssst.ReferenceType = '159' then ssst.Reference end)--Qualifier Type of 159
	,	UserDefined6 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined7 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined8 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined9 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined10 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined11 = max(case when ssst.ReferenceType = '11Z' then ssst.Reference end)
	,	UserDefined12 = max(case when ssst.ReferenceType = '12Z' then ssst.Reference end)
	,	UserDefined13 = max(case when ssst.ReferenceType = '13Z' then ssst.Reference end)
	,	UserDefined14 = max(case when ssst.ReferenceType = '14Z' then ssst.Reference end)
	,	UserDefined15 = max(case when ssst.ReferenceType = '15Z' then ssst.Reference end)
	,	UserDefined16 = max(case when ssst.ReferenceType = '16Z' then ssst.Reference end)
	,	UserDefined17 = max(case when ssst.ReferenceType = '17Z' then ssst.Reference end)
	,	UserDefined18 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	,	UserDefined19 = max(case when ssst.ReferenceType = '16' then ssst.Reference end)
	,	UserDefined20 = max(case when ssst.ReferenceType = '??' then ssst.Reference end)
	from
		@PlanningReleaseSupplementalTemp ssst
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
	select '#PlanningSupplemental', @toc
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
	@ProcReturn = EDIEDIFACT97A.usp_Stage1_GetPlanningSupplimental
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
