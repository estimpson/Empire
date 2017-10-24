CREATE TABLE [dbo].[adm_opu_opciones_role]
(
[opu_role] [int] NOT NULL,
[opu_codopm] [int] NOT NULL,
[opu_acceso] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_opu_opciones_role] ADD CONSTRAINT [PK_adm_opu_opciones_role] PRIMARY KEY CLUSTERED  ([opu_role], [opu_codopm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_opu_opciones_role] WITH NOCHECK ADD CONSTRAINT [FK_adm_opu_opciones_role_adm_opm_opciones_menu] FOREIGN KEY ([opu_codopm]) REFERENCES [dbo].[adm_opm_opciones_menu] ([opm_codigo]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[adm_opu_opciones_role] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[adm_opu_opciones_role] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[adm_opu_opciones_role] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[adm_opu_opciones_role] TO [APPUser]
GO
