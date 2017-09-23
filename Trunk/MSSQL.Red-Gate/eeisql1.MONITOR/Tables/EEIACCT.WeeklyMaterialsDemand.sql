CREATE TABLE [EEIACCT].[WeeklyMaterialsDemand]
(
[GenerationDT] [datetime] NOT NULL,
[GenerationWeekNo] AS (datediff(week,'2009-01-01',[GenerationDT])),
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BucketDT] [datetime] NOT NULL,
[Vendor] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POQty] [numeric] (20, 6) NULL,
[UnitCost] [numeric] (20, 6) NULL,
[ExtendedPODue] [numeric] (20, 6) NULL,
[ReceiveQty] [numeric] (20, 6) NULL,
[ExtendedPOReceived] [numeric] (20, 6) NULL,
[StdPack] [numeric] (20, 6) NULL,
[OverReceiptQty] [numeric] (20, 6) NULL,
[OverReceiptExtended] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[WeeklyMaterialsDemand] ADD CONSTRAINT [PK__WeeklyMaterialsD__43332DD0] PRIMARY KEY CLUSTERED  ([GenerationDT], [PONumber], [Part], [BucketDT]) ON [PRIMARY]
GO
