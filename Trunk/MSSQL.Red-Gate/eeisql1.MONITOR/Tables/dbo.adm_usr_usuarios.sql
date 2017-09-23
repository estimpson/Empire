CREATE TABLE [dbo].[adm_usr_usuarios]
(
[usr_codigo] [int] NOT NULL,
[usr_usuario] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_password] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_nombre] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_codemp] [int] NULL,
[usr_tipo_autentificacion] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_operator_code] [nchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_Codigo_Empleado] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[usr_email] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextChangePassword] [datetime] NULL CONSTRAINT [DF_adm_usr_usuarios_NextChangePassword] DEFAULT (getdate()+(5)),
[usr_castigado] [bit] NULL,
[usr_FechaFinCastigo] [datetime] NULL,
[usr_Pin] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_usr_usuarios] ADD CONSTRAINT [PK_adm_usr_usuarios] PRIMARY KEY CLUSTERED  ([usr_codigo]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[adm_usr_usuarios] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[adm_usr_usuarios] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[adm_usr_usuarios] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[adm_usr_usuarios] TO [APPUser]
GO
