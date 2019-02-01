CREATE TABLE [HN].[Putaway_log_Details]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[id_Putaway_log] [int] NULL,
[Caracteristica] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resultado] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Putaway_log_Details] ADD CONSTRAINT [PK_Putaway_log_Details] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
