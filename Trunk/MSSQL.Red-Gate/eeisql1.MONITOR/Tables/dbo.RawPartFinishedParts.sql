CREATE TABLE [dbo].[RawPartFinishedParts]
(
[RawPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinishedPart] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Quantity] [numeric] (38, 12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RawPartFinishedParts] ADD CONSTRAINT [PK_RawPartFinishedParts] PRIMARY KEY NONCLUSTERED  ([RawPart], [FinishedPart]) ON [PRIMARY]
GO
