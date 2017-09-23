CREATE TABLE [FT].[ReceiptReversals]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DbDT] [datetime] NOT NULL CONSTRAINT [DF__ReceiptRev__DbDT__569ECEE8] DEFAULT (getdate()),
[ContainingPeriodID] [int] NULL,
[ObjectSerial] [int] NULL,
[PONumber] [int] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReceiptDT] [datetime] NULL,
[ReceiptStdQty] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReceiptReversals] ADD CONSTRAINT [PK__ReceiptReversals__55AAAAAF] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReceiptReversals] ADD CONSTRAINT [FK__ReceiptRe__Conta__532343BF] FOREIGN KEY ([ContainingPeriodID]) REFERENCES [FT].[ReceiptPeriods] ([ID])
GO
