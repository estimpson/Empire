CREATE TABLE [dbo].[adm_rol_roles]
(
[rol_codigo] [int] NOT NULL,
[rol_role] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_rol_roles] ADD CONSTRAINT [PK_seg_rol_roles] PRIMARY KEY CLUSTERED  ([rol_codigo]) ON [PRIMARY]
GO
