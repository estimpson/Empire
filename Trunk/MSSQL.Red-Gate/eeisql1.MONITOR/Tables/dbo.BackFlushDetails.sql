CREATE TABLE [dbo].[BackFlushDetails]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BFID] [int] NULL,
[BOMID] [int] NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialConsumed] [int] NULL,
[QtyAvailable] [numeric] (20, 6) NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[QtyIssue] [numeric] (20, 6) NULL,
[QtyOverage] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BackFlushDetails] ADD CONSTRAINT [PK__BackFlushDetails__24999817] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BackFlushDetails] ADD CONSTRAINT [FK__BackFlushD__BFID__258DBC50] FOREIGN KEY ([BFID]) REFERENCES [dbo].[BackFlushHeaders] ([ID])
GO
