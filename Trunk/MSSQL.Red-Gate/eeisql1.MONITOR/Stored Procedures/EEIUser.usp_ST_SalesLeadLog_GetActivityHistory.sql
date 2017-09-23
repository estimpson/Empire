SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_ST_SalesLeadLog_GetActivityHistory]
	@SalesLeadId int
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
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
select
	coalesce(e.name, '') as SalesPerson
,	sd.StatusType
,	slld.Activity
,	slld.ActivityDate
,	slld.ContactName
,	slld.ContactPhoneNumber
,	slld.ContactEmailAddress
,	slld.Duration
,	slld.Notes
,	slld.QuoteNumber
,	slld.AwardedVolume
,	slld.RowID
from
	EEIUser.ST_SalesLeadLog_Detail slld
	join EEIUser.ST_SalesLeadLog_StatusDefinition sd
		on sd.StatusValue = slld.Status
	join EEIUser.ST_SalesLeadLog_Header sllh
		on sllh.RowID = slld.SalesLeadId
	left join dbo.employee e
		on e.operator_code = slld.SalesPersonCode
where
	slld.SalesLeadId = @SalesLeadId
order by
	slld.ActivityDate
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
