CREATE TABLE [EEIACCT].[TransferPriceAdjustments]
(
[GenerationDT] [datetime] NOT NULL,
[GenerationWeekNo] AS (datediff(week,'2009-01-01',[GenerationDT])),
[Adjustment] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[TransferPriceAdjustments] ADD CONSTRAINT [PK__TransferPriceAdj__144334BD] PRIMARY KEY CLUSTERED  ([GenerationDT]) ON [PRIMARY]
GO
