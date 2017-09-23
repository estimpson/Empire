CREATE TABLE [dbo].[SA_Modulos]
(
[Modulo_ID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionRed] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icono] [image] NULL,
[FechaVerificacionAsignacionPersonalSoporte] [datetime] NULL,
[RequiereReinstalacion] [bit] NULL CONSTRAINT [DF_SA_Modulos_RequiereReinstalacion] DEFAULT ((0)),
[NombreExe] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceDir] [nvarchar] (350) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DireccionFuente] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DireccionDestino] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SA_Modulos] ADD CONSTRAINT [PK_SA_Modulos] PRIMARY KEY CLUSTERED  ([Modulo_ID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SA_Modulos] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[SA_Modulos] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[SA_Modulos] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[SA_Modulos] TO [APPUser]
GO
