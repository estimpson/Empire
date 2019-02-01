SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_QT_InsertQuoteLTA]
	@QuoteNumber varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
if not exists
	(	select	ql.ModelYear
		from	EEIUser.QT_QuoteLog ql
		where	ql.QuoteNumber = @QuoteNumber
				and ql.ModelYear is not null) begin
	RAISERROR ('A model year must be tied to this quote before LTA data can be entered.', 16, 1)
	set	@Result = 999000
	rollback tran @ProcName
	return
end		
---	</ArgumentValidation>


--- <Body>	
declare @ModelYear varchar(10)
select
	@ModelYear = ql.ModelYear
from
	EEIUser.QT_QuoteLog ql
where
	ql.QuoteNumber = @QuoteNumber	


insert EEIUser.QT_QuoteLTA
(
	QuoteNumber
,	EffectiveDate
,	Percentage
,	LTAYear
)
select
	QuoteNumber = @QuoteNumber
,	EffectivDate = @ModelYear + 1
,	Percentage = 0
,	LTAYear = 1


insert EEIUser.QT_QuoteLTA
(
	QuoteNumber
,	EffectiveDate
,	Percentage
,	LTAYear
)
select
	QuoteNumber = @QuoteNumber
,	EffectivDate = @ModelYear + 2
,	Percentage = 0
,	LTAYear = 2


insert EEIUser.QT_QuoteLTA
(
	QuoteNumber
,	EffectiveDate
,	Percentage
,	LTAYear
)
select
	QuoteNumber = @QuoteNumber
,	EffectivDate = @ModelYear + 3
,	Percentage = 0
,	LTAYear = 3


insert EEIUser.QT_QuoteLTA
(
	QuoteNumber
,	EffectiveDate
,	Percentage
,	LTAYear
)
select
	QuoteNumber = @QuoteNumber
,	EffectivDate = @ModelYear + 4
,	Percentage = 0
,	LTAYear = 4
--- </Body>



--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
