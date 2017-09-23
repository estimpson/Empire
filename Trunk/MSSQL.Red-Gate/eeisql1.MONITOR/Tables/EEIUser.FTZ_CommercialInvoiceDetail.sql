CREATE TABLE [EEIUser].[FTZ_CommercialInvoiceDetail]
(
[BillofLading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsolidatedInvoiceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceDate] [datetime] NULL,
[PackageCount] [decimal] (18, 6) NULL,
[CountryofOrigin] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchandiseDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTSUS] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 6) NULL,
[GrossWeight] [decimal] (18, 6) NULL,
[Value] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[FTZ_CommercialInvoiceDetail] ADD CONSTRAINT [PK_FTZ_CommercialInvoiceDetail] PRIMARY KEY CLUSTERED  ([ConsolidatedInvoiceNo], [InvoiceNo]) ON [PRIMARY]
GO
