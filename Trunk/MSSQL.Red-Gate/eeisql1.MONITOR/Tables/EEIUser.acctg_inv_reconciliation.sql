CREATE TABLE [EEIUser].[acctg_inv_reconciliation]
(
[id] [uniqueidentifier] NOT NULL CONSTRAINT [DF__acctg_inv_re__id__0A9C5E92] DEFAULT (newid()),
[P_ProductLine] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[P_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[P_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PS_price] [decimal] (18, 6) NULL,
[PS_material_cum] [decimal] (18, 6) NULL,
[PS_frozen_material_cum] [decimal] (18, 6) NULL,
[date_updated] [datetime] NULL,
[NJB_Number] [int] NULL,
[NJB_Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NJB_QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NJB_ProductionSelling] [decimal] (18, 4) NULL,
[NJB_SellingPrice] [decimal] (18, 4) NULL,
[NJB_TransferPrice] [decimal] (18, 2) NULL,
[QL_QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QL_CustomerQuoteDate] [datetime] NULL,
[QL_Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QL_ProductionPrice] [decimal] (18, 4) NULL,
[QL_PrototypePrice] [decimal] (18, 4) NULL,
[QL_TransferPrice] [decimal] (18, 2) NULL,
[QL_LTAs] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SO_order_no] [numeric] (8, 0) NULL,
[SO_customer_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SO_customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SO_destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SO_price] [decimal] (18, 4) NULL,
[SO_TransferPrice] [decimal] (18, 2) NULL,
[OH_qty_on_hand] [decimal] (18, 2) NULL,
[OH_price] [decimal] (18, 6) NULL,
[OH_TransferPrice] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_inv_reconciliation] ADD CONSTRAINT [pk_acctg_inv_reconciliation2a] PRIMARY KEY CLUSTERED  ([id], [P_part]) ON [PRIMARY]
GO
