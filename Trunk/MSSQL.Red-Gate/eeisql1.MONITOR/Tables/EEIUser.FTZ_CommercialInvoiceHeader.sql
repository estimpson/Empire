CREATE TABLE [EEIUser].[FTZ_CommercialInvoiceHeader]
(
[Box6_ZoneAdmissionNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillofLading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContainerNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsolidatedInvoiceNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConsolidatedInvoiceDate] [datetime] NULL,
[ConsolidatedInvoiceQuantity] [decimal] (18, 6) NULL,
[ConsolidatedInvoiceTotal] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[FTZ_CommercialInvoiceHeader] ADD CONSTRAINT [PK_FTZ_CommercialInvoiceHeader] PRIMARY KEY CLUSTERED  ([BillofLading], [ConsolidatedInvoiceNo]) ON [PRIMARY]
GO
