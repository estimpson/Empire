CREATE TABLE [dbo].[adm_rus_role_usuarios]
(
[rus_role] [int] NOT NULL,
[rus_codusr] [int] NOT NULL,
[rus_rol_ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_rus_role_usuarios] ADD CONSTRAINT [PK_seg_rus_role_usuarios] PRIMARY KEY CLUSTERED  ([rus_rol_ID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[adm_rus_role_usuarios] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[adm_rus_role_usuarios] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[adm_rus_role_usuarios] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[adm_rus_role_usuarios] TO [APPUser]
GO
