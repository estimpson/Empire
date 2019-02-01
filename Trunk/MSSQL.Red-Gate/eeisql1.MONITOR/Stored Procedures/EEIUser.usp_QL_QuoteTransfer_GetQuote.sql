SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_GetQuote]
	@QuoteNumber varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()

declare
	@initialtrancount int = @@trancount
if	@initialtrancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName


---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
select
	ql.QuoteNumber
,	getdate() as [Date]
,	ql.Customer
,	ql.EEIPartNumber as EmpirePartNumber
,	ql.CustomerPartNumber
,	ql.Program
,	ql.ApplicationName as [Application]
,	ql.EAU as FinancialEau
,	ql.EAU * 1.2 as CapacityEau
,	coalesce(si.FirstName, '') + ' ' + coalesce(si.LastName, '') as Salesman
,	coalesce(emi.FirstName, '') + ' ' + coalesce(emi.LastName, '') as QuoteEngineer
,	coalesce(pmi.FirstName, '') + ' ' + coalesce(pmi.LastName, '') as ProgramManager
,	ql.QuotePrice as SalesPrice
,	case
		when ql.QuotePrice is not null and Lta1.LtaPercentage1 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta1.LtaPercentage1)
		else 0
	end as LtaYear1
,	case
		when ql.QuotePrice is not null and Lta2.LtaPercentage2 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta2.LtaPercentage2)
		else 0
	end as LtaYear2
,	case
		when ql.QuotePrice is not null and Lta3.LtaPercentage3 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta3.LtaPercentage3)
		else 0
	end as LtaYear3
,	case
		when ql.QuotePrice is not null and Lta4.LtaPercentage4 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta4.LtaPercentage4)
		else 0
	end as LtaYear4
,	ql.PrototypePrice
,	ql.MinimumOrderQuantity
,	ql.StraightMaterialCost as Material
,	ql.StdHours as Labor
,	ql.Tooling
,	ql.SOP
,	ql.EOP
,	coalesce(ql.QuoteTransferComplete, 'N') as QuoteTransferComplete
from
	eeiuser.QT_QuoteLog ql
	left join eeiuser.QT_SalesInitials si
		on si.Initials = ql.SalesInitials
	left join eeiuser.QT_EngineeringMaterialsInitials emi
		on emi.Initials = ql.EngineeringMaterialsInitials
	left join eeiuser.QT_ProgramManagerInitials pmi
		on pmi.Initials = ql.ProgramManagerInitials
	outer apply (
			select coalesce(lta.Percentage, 0) as LtaPercentage1
			from eeiuser.QT_QuoteLTA lta
			where lta.LTAYear = 1 and lta.QuoteNumber = ql.QuoteNumber ) Lta1
	outer apply (
			select coalesce(lta.Percentage, 0) as LtaPercentage2
			from eeiuser.QT_QuoteLTA lta
			where lta.LTAYear = 2 and lta.QuoteNumber = ql.QuoteNumber ) Lta2
	outer apply (
			select coalesce(lta.Percentage, 0) as LtaPercentage3
			from eeiuser.QT_QuoteLTA lta
			where lta.LTAYear = 3 and lta.QuoteNumber = ql.QuoteNumber ) Lta3
	outer apply (
			select coalesce(lta.Percentage, 0) as LtaPercentage4
			from eeiuser.QT_QuoteLTA lta
			where lta.LTAYear = 4 and lta.QuoteNumber = ql.QuoteNumber ) Lta4
where
	ql.QuoteNumber = @QuoteNumber
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
