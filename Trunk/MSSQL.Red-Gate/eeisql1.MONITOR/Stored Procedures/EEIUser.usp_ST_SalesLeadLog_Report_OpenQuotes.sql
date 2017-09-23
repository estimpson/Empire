SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_ST_SalesLeadLog_Report_OpenQuotes]
	@TranDT datetime = null out
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
with cte_Header (EEIPartNumber, RowID) as 
(
select
	qql.EEIPartNumber
,	max(qql.RowID) as RowID
from
	EEIUser.QT_QuoteLog qql
where
	qql.QuoteStatus = 'COMPLETED' 
	and qql.RowCreateDT >= dateadd(year, -1, getdate())
group by
	qql.EEIPartNumber
)

select
	qql.QuoteStatus
,	qql.Customer
,	qql.Program
,	qql.ApplicationName
,	qql.SalesInitials
,	case
		when qql.SOP is null then ''
		else convert(varchar, convert(date, qql.SOP))
	end as SOP
,	case
		when qql.EOP is null then ''
		else convert(varchar, convert(date, qql.EOP))
	end as EOP
,	qql.EEIPartNumber
,	coalesce(qql.TotalQuotedSales, 0) as TotalQuotedSales
,	qql.Notes
,	qql.EAU
,	coalesce(qql.QuotePrice, 0) as QuotePrice
,	case
		when qql.QuotePricingDate is null then ''
		else convert(varchar, convert(date, qql.QuotePricingDate))
	end as QuotePricingDate
,	coalesce(qql.Awarded, '') as Awarded
,	case
		when (isnull(qql.StraightMaterialCost, 0) > 0) and (isnull(qql.QuotePrice, 0) > 0) then convert(decimal(10,3), (qql.StraightMaterialCost / qql.QuotePrice))
		else 0
	end as MaterialPercentage
from 
	EEIUser.QT_QuoteLog qql
	join cte_Header h
		on h.EEIPartNumber = qql.EEIPartNumber
		and h.RowID = qql.RowID
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
