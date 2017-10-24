CREATE TABLE [FT].[ReceiptPeriods]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PeriodEndDT] [datetime] NOT NULL CONSTRAINT [DF__ReceiptPe__Perio__4B422AD5] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReceiptPeriods] ADD CONSTRAINT [PK__ReceiptPeriods__4A4E069C] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
