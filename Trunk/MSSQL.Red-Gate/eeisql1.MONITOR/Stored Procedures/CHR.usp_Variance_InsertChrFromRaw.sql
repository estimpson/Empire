SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [CHR].[usp_Variance_InsertChrFromRaw]
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
			CHR.Variance v
			join CHR.VarianceRawDataTemp t
				on convert(bigint, t.ChrNumber) = v.ChrNumber ) begin

	set	@Result = 999991
	RAISERROR ('One or more records exist in the database with the same CHR number.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end		
---	</ArgumentValidation>



--- <Body>
--- <Insert rows="1+">	
set	@TableName = 'CHR.Variance'
insert into CHR.Variance
(
	OriginPickupCity
,	OriginPickupState
,	DestinationDeliveryCity
,	DestinationDeliveryState
,	PayerReferenceNumber
,	CustomerReferenceNumber
,	ChrNumber
,	ActualQuantity
,	ActualPallets
,	ActualWeight
,	Hazardous
,	Commodity
,	[Description]
,	PalletSpaces
,	DriverHeavyWeightTix
,	ActualPackagingCode
,	ChargeableWeight
,	DriverLightWeightTix
,	InnerPack
,	DimensionalWeight
,	OverDimensional
,	FreightCharge
,	TotalAccessorialsOtherCharges
,	TotalCharges
,	FuelSurcharge405
,	TransferOfLoad740
,	OrmOutOfRouteMiles
,	InvoiceTotal
,	Invoiced
,	PaymentComments
,	EndCustomerFreightCharge
,	EndCustomerTotalAccessorialCharge
,	EndCustomerTotalCharges
,	BaselineCharge
,	CarrierName
,	OperatorCode
,	RowCreateDT
)
select
	OriginPickupCity = t.OriginPickupCity
,	OriginPickupState = t.OriginPickupState
,	DestinationDeliveryCity = t.DestinationDeliveryCity
,	DestinationDeliveryState = t.DestinationDeliveryState
,	PayerReferenceNumber = t.PayerReferenceNumber
,	CustomerReferenceNumber = t.CustomerReferenceNumber
,	ChrNumber = convert(bigint, t.ChrNumber)
,	ActualQuantity = convert(int, t.ActualQuantity)
,	ActualPallets = convert(int, t.ActualPallets)
,	ActualWeight = convert(int, t.ActualWeight)
,	Hazardous = t.Hazardous
,	Commodity = t.Commodity
,	[Description] = t.[Description]
,	PalletSpaces = convert(int, t.PalletSpaces)
,	DriverHeavyWeightTix = convert(int, t.DriverHeavyWeightTix)
,	ActualPackagingCode = t.ActualPackagingCode
,	ChargeableWeight = convert(int, t.ChargeableWeight)
,	DriverLightWeightTix = convert(int, t.DriverLightWeightTix)
,	InnerPack = convert(int, t.InnerPack)
,	DimensionalWeight = convert(int, t.DimensionalWeight)
,	OverDimensional = t.OverDimensional
,	FreightCharge = convert(decimal(12,6), nullif(t.FreightCharge, '')) 
,	TotalAccessorialsOtherCharges = convert(decimal(12,6), nullif(t.TotalAccessorialsOtherCharges, '')) 
,	TotalCharges = convert(decimal(12,6), nullif(t.TotalCharges, '')) 
,	FuelSurcharge405 = convert(decimal(12,6), nullif(t.FuelSurcharge405, '')) 
,	TransferOfLoad740 = convert(decimal(12,6), nullif(t.TransferOfLoad740, '')) 
,	OrmOutOfRouteMiles = convert(int, t.OrmOutOfRouteMiles)
,	InvoiceTotal = convert(decimal(12,6), nullif(t.InvoiceTotal, '')) 
,	Invoiced = t.Invoiced
,	PaymentComments = t.PaymentComments
,	EndCustomerFreightCharge = convert(decimal(12,6), nullif(t.EndCustomerFreightCharge, '')) 
,	EndCustomerTotalAccessorialCharge = convert(decimal(12,6), nullif(t.EndCustomerTotalAccessorialCharge, '')) 
,	EndCustomerTotalCharges = convert(decimal(12,6), nullif(t.EndCustomerTotalCharges, '')) 
,	BaselineCharge = convert(decimal(12,6), nullif(t.BaselineCharge, '')) 
,	CarrierName = t.CarrierName
,	OperatorCode = @OperatorCode
,	RowCreateDT = @TranDT
from
	CHR.VarianceRawDataTemp t


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
