SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_SalesLeadLog_Hitlist_GetActivity]
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
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
	join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = hl.ID
	join eeiuser.ST_SalesLeadLog_Detail d
		on d.SalesLeadId = h.RowID
where
	h.Status < 3 -- sales lead has not been awarded or closed
	and h.SalesPersonCode = @SalesPersonCode
group by
	h.RowID
)

select
	hl.Customer
,	hl.Program
,	hl.[Application]
,	convert(varchar, convert(date, hl.SOP)) as SOP
,	convert(varchar, convert(date, hl.EOP)) as EOP
,	hl.PeakYearlyVolume
,	convert(varchar, convert(date, slld.ActivityDate)) as LastSalesActivity
,	sd.StatusType as [Status]
,	hl.ID as ID
,	sllh.RowID as SalesLeadID
from 
	EEIUser.ST_SalesLeadLog_Header sllh
	join EEIUser.ST_LightingStudy_Hitlist_2016 hl
		on hl.ID = sllh.CombinedLightingId
	join EEIUser.ST_SalesLeadLog_Detail slld
		on slld.SalesLeadId = sllh.RowID
	join EEIUser.ST_SalesLeadLog_StatusDefinition sd
		on sd.StatusValue = slld.Status
	join cte_Header cte
		on cte.RowID = sllh.RowID
		and cte.ActivityDate = slld.ActivityDate
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
