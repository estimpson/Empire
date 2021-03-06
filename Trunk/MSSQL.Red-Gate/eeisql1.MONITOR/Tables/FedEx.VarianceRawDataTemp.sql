CREATE TABLE [FedEx].[VarianceRawDataTemp]
(
[BillToAccountNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalAmountDue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentBalance] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroundTrackingIdPrefix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpressOrGroundTrackingId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransportationChargeAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetChargeAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroundService] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipmentDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PodDeliveryDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PodDeliveryTime] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PodServiceAreaCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PodSignatureDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActualWeightAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActualWeightUnits] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatedWeightAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatedWeightUnits] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfPieces] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BundleNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MeterNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TdMasterTrackingId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServicePackaging] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimLength] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimWidth] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimHeight] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimDivisor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimUnit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientAddressLine1] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientAddressLine2] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperAddressLine1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperAddressLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalCustomerReference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRefNumber2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRefNumber3PoNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalDepartmentReferenceDesc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedCustomerReference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedRefNumber2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedRefNumber3PoNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDepartmentReferenceDesc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RmaNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientAddressLine1] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientAddressLine2] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalRecipientCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZoneCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CostAllocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateAddressLine1] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateAddressLine2] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateStateProvince] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateCountryCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrossRefTrackingIdPrefix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrossRefTrackingId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomsValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomsValueCurrencyCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeclaredValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeclaredValueCurrencyCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityDescription1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityCountryCode1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityDescription2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityCountryCode2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityDescription3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityCountryCode3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityDescription4] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommodityCountryCode4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyConversionDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyConversionRate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiweightNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiweightTotalUnits] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiweightTotalWeight] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiweightTotalShipmentChargeAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiweightTotalShipmentWeight] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroundTrackingIdAddressCorrectionDiscountChargeAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroundTrackingIdAddressCorrectionGrossChargeAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatedMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortHub] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EstimatedWeight] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EstimatedWeightUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalClass] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessCategory] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackageSize] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryConfirmation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenderedDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription3] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription4] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription5] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription6] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription7] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription8] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription9] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription10] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription11] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount11] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription12] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount12] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription13] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount13] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription14] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount14] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription15] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount15] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription16] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount16] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription17] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount17] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription18] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount18] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription19] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount19] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription20] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount20] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription21] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount21] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription22] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount22] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription23] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount23] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription24] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount24] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeDescription25] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackingIdChargeAmount25] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipmentNotes] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
