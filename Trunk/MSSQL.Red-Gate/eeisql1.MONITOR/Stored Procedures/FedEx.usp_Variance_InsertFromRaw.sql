SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [FedEx].[usp_Variance_InsertFromRaw]
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

/*  No primary key exceptions  */
if exists (
		select
			fev.ExpressOrGroundTrackingId
		from
			FedEx.Variance fev
			join FedEx.VarianceRawDataTemp t
				on convert(bigint, t.ExpressOrGroundTrackingId) = fev.ExpressOrGroundTrackingId	) begin

	set	@Result = 999991
	RAISERROR ('One or more of these records have already been imported into the database.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end				
---	</ArgumentValidation>



--- <Body>
--- <Insert rows="1+">	
set	@TableName = 'FedEx.Variance'
insert into FedEx.Variance
(
	BillToAccountNumber
,	InvoiceDate
,	InvoiceNumber
,	StoreId
,	OriginalAmountDue
,	CurrentBalance
,	Payor
,	GroundTrackingIdPrefix
,	ExpressOrGroundTrackingId
,	TransportationChargeAmount
,	NetChargeAmount
,	ServiceType
,	GroundService
,	ShipmentDate
,	PodDeliveryDate
,	PodServiceAreaCode
,	PodSignatureDescription
,	ActualWeightAmount
,	ActualWeightUnits
,	RatedWeightAmount
,	RatedWeightUnits
,	NumberOfPieces
,	BundleNumber
,	MeterNumber
,	TdMasterTrackingId
,	ServicePackaging
,	DimLength
,	DimWidth
,	DimHeight
,	DimDivisor
,	DimUnit
,	RecipientName
,	RecipientCompany
,	RecipientAddressLine1
,	RecipientAddressLine2
,	RecipientCity
,	RecipientState
,	RecipientZipCode
,	RecipientCountry
,	ShipperCompany
,	ShipperName
,	ShipperAddressLine1
,	ShipperAddressLine2
,	ShipperCity
,	ShipperState
,	ShipperZipCode
,	ShipperCountry
,	OriginalCustomerReference
,	OriginalRefNumber2
,	OriginalRefNumber3PoNumber
,	OriginalDepartmentReferenceDesc
,	UpdatedCustomerReference
,	UpdatedRefNumber2
,	UpdatedRefNumber3PoNumber
,	UpdatedDepartmentReferenceDesc
,	RmaNumber
,	OriginalRecipientAddressLine1
,	OriginalRecipientAddressLine2
,	OriginalRecipientCity
,	OriginalRecipientState
,	OriginalRecipientZipCode
,	OriginalRecipientCountry
,	ZoneCode
,	CostAllocation
,	AlternateAddressLine1
,	AlternateAddressLine2
,	AlternateCity
,	AlternateStateProvince
,	AlternateZipCode
,	AlternateCountryCode
,	CrossRefTrackingIdPrefix
,	CrossRefTrackingId
,	EntryDate
,	EntryNumber
,	CustomsValue
,	CustomsValueCurrencyCode
,	DeclaredValue
,	DeclaredValueCurrencyCode
,	CommodityDescription1
,	CommodityCountryCode1
,	CommodityDescription2
,	CommodityCountryCode2
,	CommodityDescription3
,	CommodityCountryCode3
,	CommodityDescription4
,	CommodityCountryCode4
,	CommodityDescription5
,	CommodityCountryCode5
,	CurrencyConversionDate
,	CurrencyConversionRate
,	MultiweightNumber
,	MultiweightTotalUnits
,	MultiweightTotalWeight
,	MultiweightTotalShipmentChargeAmount
,	MultiweightTotalShipmentWeight
,	GroundTrackingIdAddressCorrectionDiscountChargeAmount
,	GroundTrackingIdAddressCorrectionGrossChargeAmount
,	RatedMethod
,	SortHub
,	EstimatedWeight
,	EstimatedWeightUnit
,	PostalClass
,	ProcessCategory
,	PackageSize
,	DeliveryConfirmation
,	TenderedDate
,	TrackingIdChargeDescription1
,	TrackingIdChargeAmount1
,	TrackingIdChargeDescription2
,	TrackingIdChargeAmount2
,	TrackingIdChargeDescription3
,	TrackingIdChargeAmount3
,	TrackingIdChargeDescription4
,	TrackingIdChargeAmount4
,	TrackingIdChargeDescription5
,	TrackingIdChargeAmount5
,	TrackingIdChargeDescription6
,	TrackingIdChargeAmount6
,	TrackingIdChargeDescription7
,	TrackingIdChargeAmount7
,	TrackingIdChargeDescription8
,	TrackingIdChargeAmount8
,	TrackingIdChargeDescription9
,	TrackingIdChargeAmount9
,	TrackingIdChargeDescription10
,	TrackingIdChargeAmount10
,	TrackingIdChargeDescription11
,	TrackingIdChargeAmount11
,	TrackingIdChargeDescription12
,	TrackingIdChargeAmount12
,	TrackingIdChargeDescription13
,	TrackingIdChargeAmount13
,	TrackingIdChargeDescription14
,	TrackingIdChargeAmount14
,	TrackingIdChargeDescription15
,	TrackingIdChargeAmount15
,	TrackingIdChargeDescription16
,	TrackingIdChargeAmount16
,	TrackingIdChargeDescription17
,	TrackingIdChargeAmount17
,	TrackingIdChargeDescription18
,	TrackingIdChargeAmount18
,	TrackingIdChargeDescription19
,	TrackingIdChargeAmount19
,	TrackingIdChargeDescription20
,	TrackingIdChargeAmount20
,	TrackingIdChargeDescription21
,	TrackingIdChargeAmount21
,	TrackingIdChargeDescription22
,	TrackingIdChargeAmount22
,	TrackingIdChargeDescription23
,	TrackingIdChargeAmount23
,	TrackingIdChargeDescription24
,	TrackingIdChargeAmount24
,	TrackingIdChargeDescription25
,	TrackingIdChargeAmount25
,	ShipmentNotes
,	OperatorCode
,	RowCreateDT
)
select
	BillToAccountNumber = convert(bigint, t.BillToAccountNumber)
,	InvoiceDate = convert(datetime, t.InvoiceDate)
,	InvoiceNumber = convert(bigint, t.InvoiceNumber)
,	StoreId = convert(int, t.StoreId)
,	OriginalAmountDue = convert(decimal(12,6), t.OriginalAmountDue)
,	CurrentBalance = convert(decimal(12,6), t.CurrentBalance)
,	Payor = t.Payor
,	GroundTrackingIdPrefix = convert(int, t.GroundTrackingIdPrefix) 
,	ExpressOrGroundTrackingId = convert(bigint, t.ExpressOrGroundTrackingId)
,	TransportationChargeAmount = convert(decimal(12,6), t.TransportationChargeAmount)
,	NetChargeAmount = convert(decimal(12,6), t.NetChargeAmount)
,	ServiceType = t.ServiceType
,	GroundService = t.GroundService
,	ShipmentDate = convert(datetime, t.ShipmentDate)
,	PodDeliveryDate = convert(datetime, t.PodDeliveryDate) + convert(datetime, t.PodDeliveryTime)
,	PodServiceAreaCode = t.PodServiceAreaCode
,	PodSignatureDescription = t.PodSignatureDescription
,	ActualWeightAmount = convert(decimal(12,6), t.ActualWeightAmount)
,	ActualWeightUnits = t.ActualWeightUnits
,	RatedWeightAmount = convert(decimal(12,6), t.RatedWeightAmount)
,	RatedWeightUnits = t.RatedWeightUnits
,	NumberOfPieces = convert(int, t.NumberOfPieces)
,	BundleNumber = convert(int, t.BundleNumber)
,	MeterNumber = convert(bigint, t.MeterNumber)
,	TdMasterTrackingId = convert(bigint, t.TdMasterTrackingId)
,	ServicePackaging = t.ServicePackaging
,	DimLength = convert(int, t.DimLength)
,	DimWidth = convert(int, t.DimWidth)
,	DimHeight = convert(int, t.DimHeight)
,	DimDivisor = convert(int, t.DimDivisor)
,	DimUnit = convert(int, t.DimUnit)
,	RecipientName = t.RecipientName
,	RecipientCompany = t.RecipientCompany
,	RecipientAddressLine1 = t.RecipientAddressLine1
,	RecipientAddressLine2 = t.RecipientAddressLine2
,	RecipientCity = t.RecipientCity
,	RecipientState = t.RecipientState
,	RecipientZipCode = t.RecipientZipCode
,	RecipientCountry = t.RecipientCountry
,	ShipperCompany = t.ShipperCompany
,	ShipperName = t.ShipperName
,	ShipperAddressLine1 = t.ShipperAddressLine1
,	ShipperAddressLine2 = t.ShipperAddressLine2
,	ShipperCity = t.ShipperCity
,	ShipperState = t.ShipperState
,	ShipperZipCode = t.ShipperZipCode
,	ShipperCountry = t.ShipperCountry
,	OriginalCustomerReference = t.OriginalCustomerReference
,	OriginalRefNumber2 = t.OriginalRefNumber2
,	OriginalRefNumber3PoNumber = t.OriginalRefNumber3PoNumber
,	OriginalDepartmentReferenceDesc = t.OriginalDepartmentReferenceDesc
,	UpdatedCustomerReference = t.UpdatedCustomerReference
,	UpdatedRefNumber2 = t.UpdatedRefNumber2
,	UpdatedRefNumber3PoNumber = t.UpdatedRefNumber3PoNumber
,	UpdatedDepartmentReferenceDesc = t.UpdatedDepartmentReferenceDesc
,	RmaNumber = t.RmaNumber
,	OriginalRecipientAddressLine1 = t.OriginalRecipientAddressLine1
,	OriginalRecipientAddressLine2 = t.OriginalRecipientAddressLine2
,	OriginalRecipientCity = t.OriginalRecipientCity
,	OriginalRecipientState = t.OriginalRecipientState
,	OriginalRecipientZipCode = t.OriginalRecipientZipCode
,	OriginalRecipientCountry = t.OriginalRecipientCountry
,	ZoneCode = t.ZoneCode
,	CostAllocation = t.CostAllocation
,	AlternateAddressLine1 = t.AlternateAddressLine1
,	AlternateAddressLine2 = t.AlternateAddressLine2
,	AlternateCity = t.AlternateCity
,	AlternateStateProvince = t.AlternateStateProvince
,	AlternateZipCode = t.AlternateZipCode
,	AlternateCountryCode = t.AlternateCountryCode
,	CrossRefTrackingIdPrefix = convert(int, t.CrossRefTrackingIdPrefix)
,	CrossRefTrackingId = convert(bigint, t.CrossRefTrackingId)
,	EntryDate = convert(datetime, t.EntryDate)
,	EntryNumber = t.EntryNumber
,	CustomsValue = convert(int, t.CustomsValue)
,	CustomsValueCurrencyCode = t.CustomsValueCurrencyCode
,	DeclaredValue = convert(int, t.DeclaredValue)
,	DeclaredValueCurrencyCode = t.DeclaredValueCurrencyCode
,	CommodityDescription1 = t.CommodityDescription1
,	CommodityCountryCode1 = t.CommodityCountryCode1
,	CommodityDescription2 = t.CommodityDescription2
,	CommodityCountryCode2 = t.CommodityCountryCode2
,	CommodityDescription3 = t.CommodityDescription3
,	CommodityCountryCode3 = t.CommodityCountryCode3
,	CommodityDescription4 = t.CommodityDescription4
,	CommodityCountryCode4 = t.CommodityCountryCode4
,	CommodityDescription5 = t.CommodityDescription5
,	CommodityCountryCode5 = t.CommodityCountryCode5
,	CurrencyConversionDate = convert(datetime, t.CurrencyConversionDate)
,	CurrencyConversionRate = convert(decimal(12,6), t.CurrencyConversionRate)
,	MultiweightNumber = convert(int, t.MultiweightNumber)
,	MultiweightTotalUnits = convert(int, t.MultiweightNumber)
,	MultiweightTotalWeight = convert(int, t.MultiweightNumber)
,	MultiweightTotalShipmentChargeAmount = convert(decimal(12,6), t.MultiweightTotalShipmentChargeAmount)
,	MultiweightTotalShipmentWeight = convert(int, t.MultiweightTotalShipmentWeight)
,	GroundTrackingIdAddressCorrectionDiscountChargeAmount = convert(decimal(12,6), t.GroundTrackingIdAddressCorrectionDiscountChargeAmount)
,	GroundTrackingIdAddressCorrectionGrossChargeAmount = convert(decimal(12,6), t.GroundTrackingIdAddressCorrectionGrossChargeAmount)
,	RatedMethod = t.RatedMethod
,	SortHub = t.SortHub
,	EstimatedWeight = convert(int, t.EstimatedWeight)
,	EstimatedWeightUnit = convert(int, t.EstimatedWeightUnit)
,	PostalClass = t.PostalClass
,	ProcessCategory = t.ProcessCategory
,	PackageSize = t.PackageSize
,	DeliveryConfirmation = t.DeliveryConfirmation
,	TenderedDate = convert(datetime, t.TenderedDate)
,	TrackingIdChargeDescription1 = t.TrackingIdChargeDescription1
,	TrackingIdChargeAmount1 = t.TrackingIdChargeAmount1
,	TrackingIdChargeDescription2 = t.TrackingIdChargeDescription2
,	TrackingIdChargeAmount2 = t.TrackingIdChargeAmount2
,	TrackingIdChargeDescription3 = t.TrackingIdChargeDescription3
,	TrackingIdChargeAmount3 = t.TrackingIdChargeAmount3
,	TrackingIdChargeDescription4 = t.TrackingIdChargeDescription4
,	TrackingIdChargeAmount4 = t.TrackingIdChargeAmount4
,	TrackingIdChargeDescription5 = t.TrackingIdChargeDescription5
,	TrackingIdChargeAmount5 = t.TrackingIdChargeAmount5
,	TrackingIdChargeDescription6 = t.TrackingIdChargeDescription6
,	TrackingIdChargeAmount6 = t.TrackingIdChargeAmount6
,	TrackingIdChargeDescription7 = t.TrackingIdChargeDescription7
,	TrackingIdChargeAmount7 = t.TrackingIdChargeAmount7
,	TrackingIdChargeDescription8 = t.TrackingIdChargeDescription8
,	TrackingIdChargeAmount8 = t.TrackingIdChargeAmount8
,	TrackingIdChargeDescription9 = t.TrackingIdChargeDescription9
,	TrackingIdChargeAmount9 = t.TrackingIdChargeAmount9
,	TrackingIdChargeDescription10 = t.TrackingIdChargeDescription10
,	TrackingIdChargeAmount10 = t.TrackingIdChargeAmount10
,	TrackingIdChargeDescription11 = t.TrackingIdChargeDescription11
,	TrackingIdChargeAmount11 = t.TrackingIdChargeAmount11
,	TrackingIdChargeDescription12 = t.TrackingIdChargeDescription12
,	TrackingIdChargeAmount12 = t.TrackingIdChargeAmount12
,	TrackingIdChargeDescription13 = t.TrackingIdChargeDescription13
,	TrackingIdChargeAmount13 = t.TrackingIdChargeAmount13
,	TrackingIdChargeDescription14 = t.TrackingIdChargeDescription14
,	TrackingIdChargeAmount14 = t.TrackingIdChargeAmount14
,	TrackingIdChargeDescription15 = t.TrackingIdChargeDescription15
,	TrackingIdChargeAmount15 = t.TrackingIdChargeAmount15
,	TrackingIdChargeDescription16 = t.TrackingIdChargeDescription16
,	TrackingIdChargeAmount16 = t.TrackingIdChargeAmount16
,	TrackingIdChargeDescription17 = t.TrackingIdChargeDescription17
,	TrackingIdChargeAmount17 = t.TrackingIdChargeAmount17
,	TrackingIdChargeDescription18 = t.TrackingIdChargeDescription18
,	TrackingIdChargeAmount18 = t.TrackingIdChargeAmount18
,	TrackingIdChargeDescription19 = t.TrackingIdChargeDescription19
,	TrackingIdChargeAmount19 = t.TrackingIdChargeAmount19
,	TrackingIdChargeDescription20 = t.TrackingIdChargeDescription20
,	TrackingIdChargeAmount20 = t.TrackingIdChargeAmount20
,	TrackingIdChargeDescription21 = t.TrackingIdChargeDescription21
,	TrackingIdChargeAmount21 = t.TrackingIdChargeAmount21
,	TrackingIdChargeDescription22 = t.TrackingIdChargeDescription22
,	TrackingIdChargeAmount22 = t.TrackingIdChargeAmount22
,	TrackingIdChargeDescription23 = t.TrackingIdChargeDescription23
,	TrackingIdChargeAmount23 = t.TrackingIdChargeAmount23
,	TrackingIdChargeDescription24 = t.TrackingIdChargeDescription24
,	TrackingIdChargeAmount24 = t.TrackingIdChargeAmount24
,	TrackingIdChargeDescription25 = t.TrackingIdChargeDescription25
,	TrackingIdChargeAmount25 = t.TrackingIdChargeAmount25
,	ShipmentNotes = t.ShipmentNotes
,	OperatorCode = @OperatorCode
,	RowCreateDT = @TranDT
from
	FedEx.VarianceRawDataTemp t


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
