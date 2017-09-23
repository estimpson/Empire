CREATE TABLE [EEIUser].[customer_po]
(
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPORev] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[CustomerPOFileLocation] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[customer_po] ADD CONSTRAINT [PK_customer_po] PRIMARY KEY CLUSTERED  ([CustomerCode], [CustomerPO], [CustomerPORev]) ON [PRIMARY]
GO
