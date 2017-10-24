CREATE TABLE [dbo].[KB_Revisiones_Produccion]
(
[part] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[contenedorId] [int] NULL,
[DiaArranque] [smallint] NULL CONSTRAINT [DF_KB_Revisiones_Produccion_DiaArranque] DEFAULT ((0)),
[DiasProgramados] [smallint] NULL CONSTRAINT [DF_KB_Revisiones_Produccion_DiasProgramados] DEFAULT ((5)),
[CoordinadorProduccion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Validacion] [bit] NULL CONSTRAINT [DF_KB_Revisiones_Produccion_Validacion] DEFAULT ((0)),
[id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KB_Revisiones_Produccion] ADD CONSTRAINT [PK_KB_Revisiones_Produccion] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
