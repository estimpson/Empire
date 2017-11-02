SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIEDIFACT97A].[usp_Stage1_GetShipScheduleSupplemental]
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
		@ShipScheduleSupplementalTemp table
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
		@tempShipScheduleSupplemental1 table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(15)
	,	ConsigneeCode varchar(15)
	,	ShipFromCode varchar(15)
	,	SupplierCode varchar(15)		
	,	Data xml
	)

	declare
		@tempShipScheduleSupplemental2 table
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
		@tempShipScheduleSupplemental3 table
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
		@tempShipScheduleSupplemental1
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode	
	,	Data
	)
	
	select
		ed.RawDocumentGUID
	,	ReleaseNo = coalesce(ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0328"])[1]', 'varchar(30)'), ed.Data.value('(/TRN-862/SEG-BSS/DE[@code="0127"])[1]', 'varchar(30)'))
	,	ShipToCode = coalesce(EDIData.Releases.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'))
	,	ConsigneeCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="IC"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	ShipFromCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SF"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	SupplierCode = ed.Data.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SU"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	Data = EDIData.Releases.query('.')
	From	
		#ShipScheduleHeaders ed
	outer apply ed.Data.nodes('/TRN-DELJIT/LOOP-SEQ') as EDIData(Releases)
	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp1', @toc
end

	insert
		@tempShipScheduleSupplemental2
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
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-SEQ/LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	Data = EDIData.ps.query('.')
	
	from
		@tempShipScheduleSupplemental1 as ps
		cross apply ps.data.nodes('/LOOP-SEQ/LOOP-PAC/LOOP-PCI/SEG-PCI') as EDIData(ps)
	order by
		2
	,	3
	,	8
		

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp2', @toc
end

	insert
		@tempShipScheduleSupplemental3
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
	,	CustomerPart	=	coalesce(nullif((Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="BP" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''), (Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-LIN/CE/DE[@code="7143"] where $a="IN" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')) )
	,	CustomerPO		=	coalesce(nullif((Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PO" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')),''),(Data.value('(for $a in LOOP-SEQ/LOOP-LIN/LOOP-RFF/SEG-RFF/CE/DE[@code="1153"] where $a="ON" return $a/../DE[. >> $a][@code="1154"][1])[1]', 'varchar(50)')) )
	,	CustomerPOLine	=	Data.value('(for $a in LOOP-SEQ/LOOP-LIN/SEG-PIA/CE/DE[@code="7143"] where $a="PL" return $a/../DE[. << $a][@code="7140"][1])[1]', 'varchar(50)')
	,	CustomerModelYear = ''
	,	CustomerECL		=	''
	,	Data = EDIData.ps.query('.')
	
	from
		@tempShipScheduleSupplemental1 as ps
		cross apply ps.data.nodes('/LOOP-SEQ/LOOP-LIN/LOOP-LOC/SEG-LOC') as EDIData(ps)
	order by
		2
	,	3
	,	8

if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '@ShipScheduleSupplementalTemp3', @toc
end

Insert
		@ShipScheduleSupplementalTemp
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
	,	ReferenceType	=	Data.value('(/SEG-PCI/CE/DE[@code="7511"])[1]', 'varchar(50)')	
	,	ReferenceNo		=	Data.value('(/SEG-PCI/CE/DE[@code="7102"])[1]', 'varchar(50)')	
	From
		@tempShipScheduleSupplemental2 ps2

		UNION

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
	,	ReferenceType	=	Data.value('(/SEG-LOC/DE[@code="3227"])[1]', 'varchar(50)')	
	,	ReferenceNo		=	Data.value('(/SEG-LOC/CE/DE[@code="3225"])[1]', 'varchar(50)')	
	From
		@tempShipScheduleSupplemental3 ps3
	
	
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
		@ShipScheduleSupplementalTemp ssst
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
	@ProcReturn = EDIEDIFACT97A.usp_Stage1_GetShipScheduleSupplimental
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
