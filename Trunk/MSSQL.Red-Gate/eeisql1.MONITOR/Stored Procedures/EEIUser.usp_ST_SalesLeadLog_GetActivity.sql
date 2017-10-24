SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_SalesLeadLog_GetActivity]
	@SalesPersonCode varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
;
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
with cte_Header (RowID, ActivityDate) as 
(
select
	h.RowID
,	max(d.ActivityDate) as ActivityDate
from
	eeiuser.ST_LightingStudy_2016 sls
	join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	join eeiuser.ST_SalesLeadLog_Detail d
		on d.SalesLeadId = h.RowID
where
	h.Status < 3
	and h.SalesPersonCode = @SalesPersonCode
group by
	h.RowID
)

select
	ls.Customer
,	ls.Program
,	ls.[Application]
,	ls.SOP
,	ls.EOP
,	ls.PeakVolume
,	convert(varchar, convert(date, slld.ActivityDate)) as LastSalesActivity
,	sd.StatusType as [Status]
,	sllh.RowID as RowID
,	sllh.CombinedLightingId as CombinedLightingId
from 
	EEIUser.ST_SalesLeadLog_Header sllh
	join EEIUser.vw_ST_LightingStudy_2016 ls
		on ls.ID = sllh.CombinedLightingId
	join EEIUser.ST_SalesLeadLog_Detail slld
		on slld.SalesLeadId = sllh.RowID
	join EEIUser.ST_SalesLeadLog_StatusDefinition sd
		on sd.StatusValue = slld.Status
	join cte_Header cte
		on cte.RowID = sllh.RowID
		and cte.ActivityDate = slld.ActivityDate
where
	sllh.Status < 2
	and sllh.SalesPersonCode = @SalesPersonCode
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
