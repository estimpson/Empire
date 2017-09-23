CREATE TABLE [dbo].[BackFlushHeaders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[WODID] [int] NULL,
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialProduced] [int] NULL,
[QtyProduced] [numeric] (20, 6) NULL,
[TranDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BackFlushHeaders] ADD CONSTRAINT [PK__BackFlushHeaders__22B14FA5] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
