CREATE TABLE [dbo].[PottingBOM]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QtyAW] [numeric] (20, 6) NULL,
[QtyHW] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PottingBOM] ADD CONSTRAINT [PK__PottingBOM__0E1BB4D3] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
