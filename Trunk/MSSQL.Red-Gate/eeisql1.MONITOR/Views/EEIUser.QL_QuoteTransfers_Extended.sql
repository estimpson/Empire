SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[QL_QuoteTransfers_Extended]
as
select
	qt.QuoteNumber
,	ql.Customer
,	ql.EEIPartNumber as EmpirePartNumber
,	ql.CustomerPartNumber
,	ql.Program
,	ql.ApplicationName as [Application]
,	ql.EAU as FinancialEau
,	ql.EAU * 1.2 as CapacityEau
,	Salesman = coalesce(si.FirstName, '') + ' ' + coalesce(si.LastName, '')
,	QuoteEngineer = coalesce(emi.FirstName, '') + ' ' + coalesce(emi.LastName, '') 
,	ProgramManager = coalesce(pmi.FirstName, '') + ' ' + coalesce(pmi.LastName, '')
,	ql.QuotePrice as SalesPrice
,	LtaYear1 =
		case
			when ql.QuotePrice is not null and Lta1.LtaPercentage1 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta1.LtaPercentage1)
			else 0
		end
,	LtaYear2 =
		case
			when ql.QuotePrice is not null and Lta2.LtaPercentage2 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta2.LtaPercentage2)
			else 0
		end
,	LtaYear3 = 
		case
			when ql.QuotePrice is not null and Lta3.LtaPercentage3 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta3.LtaPercentage3)
			else 0
		end
,	LtaYear4 = 
		case
			when ql.QuotePrice is not null and Lta4.LtaPercentage4 > 0 then ql.QuotePrice - (ql.QuotePrice * Lta4.LtaPercentage4)
			else 0
		end 
,	ql.PrototypePrice
,	ql.MinimumOrderQuantity
,	Material = ql.StraightMaterialCost 
,	Labor = ql.StdHours
,	ql.Tooling
,	ql.SOP
,	ql.EOP
,	QuoteTransferComplete = coalesce(ql.QuoteTransferComplete, 'N')
from
	eeiuser.QL_QuoteTransfers qt
	join eeiuser.QT_QuoteLog ql
		on ql.QuoteNumber = qt.QuoteNumber
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
GO
