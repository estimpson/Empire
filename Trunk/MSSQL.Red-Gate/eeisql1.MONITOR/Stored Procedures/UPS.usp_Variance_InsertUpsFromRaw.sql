SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [UPS].[usp_Variance_InsertUpsFromRaw]
	@OperatorCode varchar(5)
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
/*  Valid operator  */
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode) begin
	
	set	@Result = 999990
	RAISERROR ('Invalid operator code.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end

/*  No duplicate data  */
if exists (
		select
			v.ID
		from
			UPS.Variance v
			join UPS.VarianceRawDataTemp t
				on convert(datetime, t.InvoiceDate) = v.InvoiceDate
				and convert(bigint, t.InvoiceNumber) = v.InvoiceNumber ) begin

	set	@Result = 999991
	RAISERROR ('One or more records exist in the database with the same invoice number and invoice date.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end		
---	</ArgumentValidation>



--- <Body>
--- <Insert rows="1+">	
set	@TableName = 'UPS.Variance'
insert into UPS.Variance
(
	[Version]
,	RecipientNumber
,	AccountNumber
,	AccountCountry	
,	InvoiceDate
,	InvoiceNumber
,	InvoiceTypeCode	
,	InvoiceTypeDetailCode
,	AccountTaxId
,	InvoiceCurrencyCode	
,	InvoiceAmount
,	TransactionDate
,	PickupRecordNumber	
,	LeadShipmentNumber	
,	WorldEaseNumber	
,	ShipmentReferenceNumber1
,	ShipmentReferenceNumber2	
,	BillOptionCode
,	PackageQuantity	
,	OversizeQuantity
,	TrackingNumber	
,	PackageReferenceNumber1
,	PackageReferenceNumber2	
,	PackageReferenceNumber3	
,	PackageReferenceNumber4	
,	PackageReferenceNumber5	
,	EnteredWeight
,	EnteredWeightUnitOfMeasure	
,	BilledWeight	
,	BilledWeightUnitOfMeasure
,	ContainerType
,	BilledWeightType	
,	PackageDimensions	
,	Zone
,	ChargeCategoryCode	
,	ChargeCategoryDetailCode	
,	ChargeSource
,	TypeCode1
,	TypeDetailCode1	
,	TypeDetailValue1	
,	TypeCode2
,	TypeDetailCode2	
,	TypeDetailValue2	
,	ChargeClassificationCode
,	ChargeDescriptionCode	
,	ChargeDescription
,	ChargedUnitQuantity	
,	BasisCurrencyCode	
,	BasisValue
,	TaxIndicator	
,	TransactionCurrencyCode	
,	IncentiveAmount
,	NetAmount
,	MiscellaneousCurrencyCode	
,	MiscellaneousIncentiveAmount
,	MiscellaneousNetAmount
,	AlternateInvoicingCurrencyCode	
,	AlternateInvoiceAmount	
,	InvoiceExchangeRate	
,	TaxVarianceAmount
,	CurrencyVarianceAmount	
,	InvoiceLevelCharge	
,	InvoiceDueDate
,	AlternateInvoiceNumber	
,	StoreNumber
,	CustomerReferenceNumber
,	SenderName	
,	SenderCompanyName
,	SenderAddressLine1	
,	SenderAddressLine2
,	SenderCity
,	SenderState	
,	SenderPostal
,	SenderCountry
,	ReceiverName	
,	ReceiverCompanyName
,	ReceiverAddressLine1
,	ReceiverAddressLine2	
,	ReceiverCity	
,	ReceiverState
,	ReceiverPostal	
,	ReceiverCountry	
,	ThirdPartyName
,	ThirdPartyCompanyName
,	ThirdPartyAddressLine1	
,	ThirdPartyAddressLine2	
,	ThirdPartyCity
,	ThirdPartyState
,	ThirdPartyPostal
,	ThirdPartyCountry
,	SoldToName
,	SoldToCompanyName
,	SoldToAddressLine1	
,	SoldToAddressLine2	
,	SoldToCity
,	SoldToState	
,	SoldToPostal	
,	SoldToCountry
,	MiscellaneousAddressQual1
,	MiscellaneousAddress1Name	
,	MiscellaneousAddress1CompanyName	
,	MiscellaneousAddress1AddressLine1
,	MiscellaneousAddress1AddressLine2
,	MiscellaneousAddress1City
,	MiscellaneousAddress1State	
,	MiscellaneousAddress1Postal	
,	MiscellaneousAddress1Country	
,	MiscellaneousAddressQual2
,	MiscellaneousAddress2Name
,	MiscellaneousAddress2CompanyName	
,	MiscellaneousAddress2AddressLine1	
,	MiscellaneousAddress2AddressLine2	
,	MiscellaneousAddress2City
,	MiscellaneousAddress2State	
,	MiscellaneousAddress2Postal	
,	MiscellaneousAddress2Country	
,	ShipmentDate
,	ShipmentExportDate	
,	ShipmentImportDate	
,	EntryDate
,	DirectShipmentDate	
,	ShipmentDeliveryDate	
,	ShipmentReleaseDate	
,	CycleDate
,	EFTDate	
,	ValidationDate	
,	EntryPort
,	EntryNumber	
,	ExportPlace	
,	ShipmentValueAmount	
,	ShipmentDescription	
,	EnteredCurrencyCode	
,	CustomsNumber
,	ExchangeRate	
,	MasterAirWaybillNumber	
,	EPU	
,	EntryType
,	CPCCode	
,	LineItemNumber
,	GoodsDescription
,	EnteredValue	
,	DutyAmount	
,	[Weight]	
,	UnitOfMeasure	
,	ItemQuantity	
,	ItemQuantityUnitOfMeasure
,	ImportTaxId
,	DeclarationNumber
,	CarrierName	
,	CCCDNumber	
,	CycleNumber	
,	ForeignTradeReferenceNumber	
,	JobNumber
,	TransportMode
,	TaxType
,	TariffCode	
,	TariffRate	
,	TariffTreatmentNumber
,	ContactName	
,	ClassNumber
,	DocumentType	
,	OfficeNumber	
,	DocumentNumber	
,	DutyValue
,	TotalValueForDuty
,	ExciseTaxAmount
,	ExciseTaxRate
,	GSTAmount
,	GSTRate
,	OrderInCouncil	
,	OriginCountry
,	SIMAAccess	
,	TaxValue	
,	TotalCustomsAmount
,	MiscellaneousLine1	
,	MiscellaneousLine2	
,	MiscellaneousLine3
,	MiscellaneousLine4	
,	MiscellaneousLine5
,	PayorRoleCode	
,	MiscellaneousLine7	
,	MiscellaneousLine8	
,	MiscellaneousLine9	
,	MiscellaneousLine10
,	MiscellaneousLine11	
,	DutyRate
,	VATBasisAmount	
,	VATAmount
,	VATRate	
,	OtherBasisAmount	
,	OtherAmount	
,	OtherRate	
,	OtherCustomsNumberIndicator	
,	OtherCustomsNumber	
,	CustomsOfficeName	
,	PackageDimensionUnitOfMeasure	
,	OriginalShipmentPackageQuantity	
,	PlaceHolder24
,	PlaceHolder25
,	PlaceHolder26
,	PlaceHolder27
,	PlaceHolder28
,	PlaceHolder29
,	PlaceHolder30
,	PlaceHolder31
,	BOLNumber1	
,	BOLNumber2	
,	BOLNumber3
,	BOLNumber4	
,	BOLNumber5	
,	PONumber1
,	PONumber2
,	PONumber3
,	PONumber4
,	PONumber5
,	PONumber6
,	PONumber7
,	PONumber8
,	PONumber9	
,	PONumber10	
,	NMFC
,	DetailClass
,	FreightSequenceNumber
,	DeclaredFreightClass
,	PlaceHolder34
,	PlaceHolder35
,	PlaceHolder36	
,	PlaceHolder37 	
,	PlaceHolder38
,	PlaceHolder39	
,	PlaceHolder40
,	PlaceHolder41
,	PlaceHolder42
,	PlaceHolder43
,	PlaceHolder44	
,	PlaceHolder45	
,	PlaceHolder46
,	PlaceHolder47
,	PlaceHolder48	
,	PlaceHolder49
,	PlaceHolder50
,	PlaceHolder51	
,	PlaceHolder52
,	PlaceHolder53 	
,	PlaceHolder54
,	PlaceHolder55
,	PlaceHolder56	
,	PlaceHolder57
,	PlaceHolder58	
,	PlaceHolder59
,	OperatorCode
,	RowCreateDT
)
select
	[Version] = t.[Version]
,	RecipientNumber = t.RecipientNumber
,	AccountNumber = t.AccountNumber
,	AccountCountry = t.AccountCountry	
,	InvoiceDate = convert(datetime, nullif(t.InvoiceDate, ''))
,	InvoiceNumber = t.InvoiceNumber
,	InvoiceTypeCode = t.InvoiceTypeCode	
,	InvoiceTypeDetailCode = t.InvoiceTypeDetailCode
,	AccountTaxId = t.AccountTaxId
,	InvoiceCurrencyCode	= t.InvoiceCurrencyCode
,	InvoiceAmount = 
	case
		when substring(t.InvoiceAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.InvoiceAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.InvoiceAmount, ',', ''), ''))
	end
,	TransactionDate = convert(datetime, nullif(t.TransactionDate, ''))
,	PickupRecordNumber = t.PickupRecordNumber	
,	LeadShipmentNumber = t.LeadShipmentNumber
,	WorldEaseNumber = t.WorldEaseNumber	
,	ShipmentReferenceNumber1 = t.ShipmentReferenceNumber1
,	ShipmentReferenceNumber2 = t.ShipmentReferenceNumber2	
,	BillOptionCode = t.BillOptionCode
,	PackageQuantity = convert(decimal(20,6), nullif(replace(t.PackageQuantity, ',', ''), ''))
,	OversizeQuantity = convert(decimal(20,6), nullif(replace(t.OversizeQuantity, ',', ''), ''))
,	TrackingNumber = t.TrackingNumber	
,	PackageReferenceNumber1 = t.PackageReferenceNumber1
,	PackageReferenceNumber2 = t.PackageReferenceNumber2	
,	PackageReferenceNumber3	= t.PackageReferenceNumber3
,	PackageReferenceNumber4 = t.PackageReferenceNumber4	
,	PackageReferenceNumber5 = t.PackageReferenceNumber5	
,	EnteredWeight = convert(decimal(20,6), nullif(replace(t.EnteredWeight, ',', ''), ''))
,	EnteredWeightUnitOfMeasure = t.EnteredWeightUnitOfMeasure	
,	BilledWeight = convert(decimal(20,6), nullif(replace(t.BilledWeight, ',', ''), ''))
,	BilledWeightUnitOfMeasure = t.BilledWeightUnitOfMeasure
,	ContainerType = t.ContainerType
,	BilledWeightType = t.BilledWeightType	
,	PackageDimensions = t.PackageDimensions
,	Zone = t.Zone
,	ChargeCategoryCode = t.ChargeCategoryCode	
,	ChargeCategoryDetailCode = t.ChargeCategoryDetailCode
,	ChargeSource = t.ChargeSource
,	TypeCode1 = t.TypeCode1
,	TypeDetailCode1	= t.TypeDetailCode1
,	TypeDetailValue1 = t.TypeDetailValue1
,	TypeCode2 = t.TypeCode2
,	TypeDetailCode2	= t.TypeDetailCode2
,	TypeDetailValue2 = t.TypeDetailValue2
,	ChargeClassificationCode = t.ChargeClassificationCode
,	ChargeDescriptionCode = t.ChargeDescriptionCode	
,	ChargeDescription = t.ChargeDescription
,	ChargedUnitQuantity = convert(decimal(20,6), nullif(replace(t.ChargedUnitQuantity, ',', ''), ''))
,	BasisCurrencyCode = t.BasisCurrencyCode	
,	BasisValue = 
	case
		when substring(t.BasisValue, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.BasisValue, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.BasisValue, ',', ''), ''))
	end
,	TaxIndicator = t.TaxIndicator
,	TransactionCurrencyCode = t.TransactionCurrencyCode	
,	IncentiveAmount = 
	case
		when substring(t.IncentiveAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.IncentiveAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.IncentiveAmount, ',', ''), ''))
	end
,	NetAmount = 
	case
		when substring(t.NetAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.NetAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.NetAmount, ',', ''), ''))
	end
,	MiscellaneousCurrencyCode = t.MiscellaneousCurrencyCode
,	MiscellaneousIncentiveAmount =
 	case
		when substring(t.MiscellaneousIncentiveAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.MiscellaneousIncentiveAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.MiscellaneousIncentiveAmount, ',', ''), ''))
	end
,	MiscellaneousNetAmount = 
	case
		when substring(t.MiscellaneousNetAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.MiscellaneousNetAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.MiscellaneousNetAmount, ',', ''), ''))
	end
,	AlternateInvoicingCurrencyCode = t.AlternateInvoicingCurrencyCode
,	AlternateInvoiceAmount =
	case
		when substring(t.AlternateInvoiceAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.AlternateInvoiceAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.AlternateInvoiceAmount, ',', ''), ''))
	end
,	InvoiceExchangeRate	= convert(decimal(20,6), nullif(replace(t.InvoiceExchangeRate, ',', ''), ''))
,	TaxVarianceAmount = 
	case
		when substring(t.TaxVarianceAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.TaxVarianceAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.TaxVarianceAmount, ',', ''), ''))
	end
,	CurrencyVarianceAmount = 	
	case
		when substring(t.CurrencyVarianceAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.CurrencyVarianceAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.CurrencyVarianceAmount, ',', ''), ''))
	end
,	InvoiceLevelCharge = 	
	case
		when substring(t.InvoiceLevelCharge, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.InvoiceLevelCharge, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.InvoiceLevelCharge, ',', ''), ''))
	end
,	InvoiceDueDate = convert(datetime, nullif(t.InvoiceDueDate, ''))
,	AlternateInvoiceNumber = t.AlternateInvoiceNumber
,	StoreNumber = t.StoreNumber
,	CustomerReferenceNumber = t.CustomerReferenceNumber
,	SenderName = t.SenderName
,	SenderCompanyName = t.SenderCompanyName
,	SenderAddressLine1 = t.SenderAddressLine1
,	SenderAddressLine2 = t.SenderAddressLine2
,	SenderCity = t.SenderCity
,	SenderState	= t.SenderState
,	SenderPostal = t.SenderPostal
,	SenderCountry = t.SenderCountry
,	ReceiverName = t.ReceiverName
,	ReceiverCompanyName = t.ReceiverCompanyName
,	ReceiverAddressLine1 = t.ReceiverAddressLine1
,	ReceiverAddressLine2 = t.ReceiverAddressLine2	
,	ReceiverCity = t.ReceiverCity
,	ReceiverState = t.ReceiverState
,	ReceiverPostal = t.ReceiverPostal
,	ReceiverCountry = t.ReceiverCountry
,	ThirdPartyName = t.ThirdPartyName
,	ThirdPartyCompanyName = t.ThirdPartyCompanyName
,	ThirdPartyAddressLine1 = t.ThirdPartyAddressLine1
,	ThirdPartyAddressLine2 = t.ThirdPartyAddressLine2
,	ThirdPartyCity = t.ThirdPartyCity
,	ThirdPartyState = t.ThirdPartyState
,	ThirdPartyPostal = t.ThirdPartyPostal
,	ThirdPartyCountry = t.ThirdPartyCountry
,	SoldToName = t.SoldToName
,	SoldToCompanyName = t.SoldToCompanyName
,	SoldToAddressLine1 = t.SoldToAddressLine1
,	SoldToAddressLine2 = t.SoldToAddressLine2
,	SoldToCity = t.SoldToCity
,	SoldToState = t.SoldToState
,	SoldToPostal = t.SoldToPostal
,	SoldToCountry = t.SoldToCountry
,	MiscellaneousAddressQual1 = t.MiscellaneousAddressQual1
,	MiscellaneousAddress1Name = t.MiscellaneousAddress1Name	
,	MiscellaneousAddress1CompanyName = t.MiscellaneousAddress1CompanyName	
,	MiscellaneousAddress1AddressLine1 = t.MiscellaneousAddress1AddressLine1
,	MiscellaneousAddress1AddressLine2 = t.MiscellaneousAddress1AddressLine2
,	MiscellaneousAddress1City = t.MiscellaneousAddress1City
,	MiscellaneousAddress1State = t.MiscellaneousAddress1State
,	MiscellaneousAddress1Postal = t.MiscellaneousAddress1Postal 	
,	MiscellaneousAddress1Country = t.MiscellaneousAddress1Country	
,	MiscellaneousAddressQual2 = t.MiscellaneousAddressQual2
,	MiscellaneousAddress2Name = t.MiscellaneousAddress2Name
,	MiscellaneousAddress2CompanyName = t.MiscellaneousAddress2CompanyName
,	MiscellaneousAddress2AddressLine1 = t.	MiscellaneousAddress2AddressLine1
,	MiscellaneousAddress2AddressLine2 = t.MiscellaneousAddress2AddressLine2
,	MiscellaneousAddress2City = t.MiscellaneousAddress2City
,	MiscellaneousAddress2State = t.MiscellaneousAddress2State	
,	MiscellaneousAddress2Postal = t.MiscellaneousAddress2Postal	
,	MiscellaneousAddress2Country = t.MiscellaneousAddress2Country
,	ShipmentDate = convert(datetime, nullif(t.ShipmentDate, ''))
,	ShipmentExportDate = convert(datetime, nullif(t.ShipmentExportDate, ''))
,	ShipmentImportDate = convert(datetime, nullif(t.ShipmentImportDate, ''))
,	EntryDate = convert(datetime, nullif(t.EntryDate, ''))
,	DirectShipmentDate = convert(datetime, nullif(t.DirectShipmentDate, ''))
,	ShipmentDeliveryDate = t.ShipmentDeliveryDate
,	ShipmentReleaseDate	= convert(datetime, nullif(t.ShipmentDate, ''))
,	CycleDate = t.CycleDate
,	EFTDate = t.EFTDate
,	ValidationDate = t.ValidationDate
,	EntryPort = t.EntryPort
,	EntryNumber	= t.EntryNumber
,	ExportPlace = t.ExportPlace
,	ShipmentValueAmount = 
	case
		when substring(t.ShipmentValueAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.ShipmentValueAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.ShipmentValueAmount, ',', ''), ''))
	end
,	ShipmentDescription = t.ShipmentDescription
,	EnteredCurrencyCode = t.EnteredCurrencyCode
,	CustomsNumber = t.CustomsNumber
,	ExchangeRate = convert(decimal(20,6), nullif(replace(t.ExchangeRate, ',', ''), ''))
,	MasterAirWaybillNumber = t.MasterAirWaybillNumber
,	EPU = t.EPU
,	EntryType = t.EntryType
,	CPCCode = t.CPCCode
,	LineItemNumber = convert(int, t.LineItemNumber)
,	GoodsDescription = t.GoodsDescription
,	EnteredValue = 
	case
		when substring(t.EnteredValue, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.EnteredValue, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.EnteredValue, ',', ''), ''))
	end
,	DutyAmount =	
	case
		when substring(t.DutyAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.DutyAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.DutyAmount, ',', ''), ''))
	end
,	[Weight] = t.[Weight]	
,	UnitOfMeasure = t.UnitOfMeasure
,	ItemQuantity = convert(int, t.ItemQuantity)
,	ItemQuantityUnitOfMeasure = t.ItemQuantityUnitOfMeasure
,	ImportTaxId = t.ImportTaxId
,	DeclarationNumber = t.DeclarationNumber
,	CarrierName	 = t.CarrierName
,	CCCDNumber = t.CCCDNumber
,	CycleNumber = t.CycleNumber
,	ForeignTradeReferenceNumber = t.ForeignTradeReferenceNumber	
,	JobNumber = t.JobNumber
,	TransportMode = t.TransportMode
,	TaxType = t.TaxType
,	TariffCode = t.TariffCode	
,	TariffRate = convert(decimal(20,6), nullif(replace(t.TariffRate, ',', ''), ''))
,	TariffTreatmentNumber = t.TariffTreatmentNumber
,	ContactName = t.ContactName	
,	ClassNumber = t.ClassNumber
,	DocumentType = t.DocumentType
,	OfficeNumber = t.OfficeNumber
,	DocumentNumber = t.DocumentNumber	
,	DutyValue = 
	case
		when substring(t.DutyValue, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.DutyValue, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.DutyValue, ',', ''), ''))
	end
,	TotalValueForDuty = 
	case
		when substring(t.TotalValueForDuty, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.TotalValueForDuty, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.TotalValueForDuty, ',', ''), ''))
	end
,	ExciseTaxAmount = 
	case
		when substring(t.ExciseTaxAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.ExciseTaxAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.ExciseTaxAmount, ',', ''), ''))
	end
,	ExciseTaxRate = convert(decimal(20,6), nullif(replace(t.ExciseTaxRate, ',', ''), ''))
,	GSTAmount = 
	case
		when substring(t.GSTAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.GSTAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.GSTAmount, ',', ''), ''))
	end
,	GSTRate = convert(decimal(20,6), nullif(replace(t.GSTRate, ',', ''), ''))
,	OrderInCouncil = t.OrderInCouncil
,	OriginCountry = t.OriginCountry
,	SIMAAccess = 
	case
		when substring(t.SIMAAccess, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.SIMAAccess, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.SIMAAccess, ',', ''), ''))
	end
,	TaxValue = 
	case
		when substring(t.TaxValue, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.TaxValue, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.TaxValue, ',', ''), ''))
	end
,	TotalCustomsAmount = 
	case
		when substring(t.TotalCustomsAmount, 1, 1) = '$' then convert(decimal(20,6), nullif(substring(replace(t.TotalCustomsAmount, ',', ''), 2, 26), ''))
		else convert(decimal(20,6), nullif(replace(t.TotalCustomsAmount, ',', ''), ''))
	end
,	MiscellaneousLine1 = t.MiscellaneousLine1
,	MiscellaneousLine2 = t.MiscellaneousLine2
,	MiscellaneousLine3 = t.MiscellaneousLine3
,	MiscellaneousLine4 = t.MiscellaneousLine4
,	MiscellaneousLine5 = t.MiscellaneousLine5
,	PayorRoleCode = t.PayorRoleCode	
,	MiscellaneousLine7 = t.MiscellaneousLine7
,	MiscellaneousLine8 = t.MiscellaneousLine8
,	MiscellaneousLine9 = t.MiscellaneousLine9
,	MiscellaneousLine10 = t.MiscellaneousLine10
,	MiscellaneousLine11 = t.MiscellaneousLine11
,	DutyRate = convert(decimal(20,6), nullif(replace(t.DutyRate, ',', ''), ''))
,	VATBasisAmount = convert(decimal(20,6), nullif(replace(t.VATBasisAmount, ',', ''), ''))
,	VATAmount = convert(decimal(20,6), nullif(replace(t.VATAmount, ',', ''), ''))
,	VATRate = convert(decimal(20,6), nullif(replace(t.VATRate, ',', ''), ''))
,	OtherBasisAmount = convert(decimal(20,6), nullif(replace(t.OtherBasisAmount, ',', ''), ''))
,	OtherAmount = convert(decimal(20,6), nullif(replace(t.OtherAmount, ',', ''), ''))
,	OtherRate = convert(decimal(20,6), nullif(replace(t.OtherRate, ',', ''), ''))
,	OtherCustomsNumberIndicator = t.OtherCustomsNumberIndicator
,	OtherCustomsNumber = t.OtherCustomsNumber
,	CustomsOfficeName = t.CustomsOfficeName
,	PackageDimensionUnitOfMeasure = t.PackageDimensionUnitOfMeasure
,	OriginalShipmentPackageQuantity	= convert(int, OriginalShipmentPackageQuantity)
,	PlaceHolder24 = t.PlaceHolder24
,	PlaceHolder25 = t.PlaceHolder25
,	PlaceHolder26 = t.PlaceHolder26
,	PlaceHolder27 = t.PlaceHolder27
,	PlaceHolder28 = t.PlaceHolder28
,	PlaceHolder29 = t.PlaceHolder29
,	PlaceHolder30 = t.PlaceHolder30
,	PlaceHolder31 = t.PlaceHolder31
,	BOLNumber1 = t.BOLNumber1
,	BOLNumber2 = t.BOLNumber2	
,	BOLNumber3 = t.BOLNumber3
,	BOLNumber4 = t.BOLNumber4
,	BOLNumber5 = t.BOLNumber5
,	PONumber1 = t.PONumber1
,	PONumber2 = t.PONumber2
,	PONumber3 = t.PONumber3
,	PONumber4 = t.PONumber4
,	PONumber5 = t.PONumber5
,	PONumber6 = t.PONumber6
,	PONumber7 = t.PONumber7
,	PONumber8 = t.PONumber8
,	PONumber9 = t.PONumber9
,	PONumber10 = t.PONumber10
,	NMFC = t.NMFC
,	DetailClass = t.DetailClass
,	FreightSequenceNumber = t.FreightSequenceNumber
,	DeclaredFreightClass = t.DeclaredFreightClass
,	PlaceHolder34 = t.PlaceHolder34
,	PlaceHolder35 = t.PlaceHolder35
,	PlaceHolder36 = t.PlaceHolder36
,	PlaceHolder37 = t.PlaceHolder37
,	PlaceHolder38 = t.PlaceHolder38
,	PlaceHolder39 = t.PlaceHolder39
,	PlaceHolder40 = t.PlaceHolder40
,	PlaceHolder41 = t.PlaceHolder41
,	PlaceHolder42 = t.PlaceHolder42
,	PlaceHolder43 = t.PlaceHolder43
,	PlaceHolder44 = t.PlaceHolder44
,	PlaceHolder45 = t.PlaceHolder45
,	PlaceHolder46 = t.PlaceHolder46
,	PlaceHolder47 = t.PlaceHolder47
,	PlaceHolder48 = t.PlaceHolder48	
,	PlaceHolder49 = t.PlaceHolder49
,	PlaceHolder50 = t.PlaceHolder50
,	PlaceHolder51 = t.PlaceHolder51	
,	PlaceHolder52 = t.PlaceHolder52
,	PlaceHolder53 = t.PlaceHolder53 	
,	PlaceHolder54 = t.PlaceHolder54
,	PlaceHolder55 = t.PlaceHolder55
,	PlaceHolder56 = t.PlaceHolder56	
,	PlaceHolder57 = t.PlaceHolder57
,	PlaceHolder58 = t.PlaceHolder58	
,	PlaceHolder59 = t.PlaceHolder59
,	OperatorCode = @OperatorCode
,	RowCreateDT = @TranDT
from
	UPS.VarianceRawDataTemp t


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error <> 0 begin
	set	@Result = 999993
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999994
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end	
--- </Insert>	
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
