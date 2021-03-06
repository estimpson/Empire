CREATE TABLE [EEIUser].[customer_po]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMasterContractID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMasterContractRev] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDICode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPORev] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPODateReceived] [datetime] NULL,
[CustomerPOEffDate] [datetime] NULL,
[CustomerPOSalesTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOShippingTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOFreightPayer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPartRev] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPartDescription] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOQuantity] [decimal] (18, 6) NULL,
[CustomerSellingPrice] [decimal] (18, 4) NULL,
[CustomerSellingPriceBegDate] [datetime] NULL,
[CustomerSellingPriceEndDate] [datetime] NULL,
[HasLTA] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTA] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTAEffectiveDates] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplacingPriorPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOFileLocation] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
