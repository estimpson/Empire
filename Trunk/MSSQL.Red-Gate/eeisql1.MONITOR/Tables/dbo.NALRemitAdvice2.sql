CREATE TABLE [dbo].[NALRemitAdvice2]
(
[LocationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PONumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorrectedInvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceReceived] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [date] NULL,
[Terms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DueDate] [date] NULL,
[PaidDate] [date] NULL,
[DiscountDate] [date] NULL,
[Discount] [decimal] (18, 6) NULL,
[Amount] [decimal] (18, 6) NULL,
[CurrencyCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClearDate] [date] NULL,
[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
