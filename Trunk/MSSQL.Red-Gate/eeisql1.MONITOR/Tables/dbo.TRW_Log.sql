CREATE TABLE [dbo].[TRW_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FGSerial] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FGCreateDT] [datetime] NULL,
[Lote] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FGPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TRW_Log] ADD CONSTRAINT [PK_TRW_Log] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
