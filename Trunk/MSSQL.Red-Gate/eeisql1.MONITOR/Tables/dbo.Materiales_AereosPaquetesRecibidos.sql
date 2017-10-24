CREATE TABLE [dbo].[Materiales_AereosPaquetesRecibidos]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TrakNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CodeOperator] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Cantidad] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Descripcion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destinatario] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Localizacion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FechaRecibo] [datetime] NULL,
[Observaciones] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LabelImpresos] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Materiales_AereosPaquetesRecibidos] ADD CONSTRAINT [PK_AereosPaquetesRecibidos] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[Materiales_AereosPaquetesRecibidos] TO [APPUser]
GO
