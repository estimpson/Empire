CREATE TABLE [dbo].[BackflushTest]
(
[BFID] [int] NOT NULL,
[OldCost] [numeric] (20, 6) NULL,
[NewCost] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BackflushTest] ADD CONSTRAINT [PK__BackflushTest__48134C3E] PRIMARY KEY CLUSTERED  ([BFID]) ON [PRIMARY]
GO
