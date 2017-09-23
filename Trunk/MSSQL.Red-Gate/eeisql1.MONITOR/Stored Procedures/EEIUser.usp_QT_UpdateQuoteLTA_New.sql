SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_UpdateQuoteLTA_New]
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
-- Get the current LTA percentages tied to the quote
declare @TempLTA table
(
	LTAYear int
,	Percentage decimal(20,0)
)

if not exists (
		select
			1
		from
			EEIUser.QT_QuoteLTA qlta
		where
			qlta.QuoteNumber = @QuoteNumber ) begin

	insert @TempLTA (LTAYear, Percentage)
	values (1,0)
	
	insert @TempLTA (LTAYear, Percentage)
	values (2,0)
	
	insert @TempLTA (LTAYear, Percentage)
	values (3,0)
	
	insert @TempLTA (LTAYear, Percentage)
	values (4,0)
end
else begin		
	insert @TempLTA
	(
		LTAYear
	,	Percentage
	)
	select
		qlta.LTAYear
	,	qlta.Percentage
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
end


-- Get the model year to base the LTAs off of	
declare @ModelYear varchar(10)
select
	@ModelYear = ql.ModelYear
from
	EEIUser.QT_QuoteLog ql
where
	ql.QuoteNumber = @QuoteNumber	
	

-- Remove the quote's LTA records
delete from 
	EEIUser.QT_QuoteLTA
where
	QuoteNumber = @QuoteNumber

	
-- Replace the quote's LTA records
insert EEIUser.QT_QuoteLTA
(
	QuoteNumber
,	EffectiveDate
,	Percentage
,	LTAYear
)
select
	QuoteNumber = @QuoteNumber
,	EffectivDate = @ModelYear + tlta.LTAYear
,	Percentage = tlta.Percentage
,	LTAYear = tlta.LTAYear
from
	@TempLTA tlta
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
