CREATE TABLE [dbo].[adm_opm_opciones_menu]
(
[opm_codigo] [int] NOT NULL,
[opm_nombre] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[opm_link] [varchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[opm_opcion_padre] [int] NULL,
[opm_orden] [int] NULL,
[opm_sistema] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_opm_opciones_menu] ADD CONSTRAINT [PK_cvon_opm_opciones_menu] PRIMARY KEY CLUSTERED  ([opm_codigo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[adm_opm_opciones_menu] WITH NOCHECK ADD CONSTRAINT [FK_adm_opm_opciones_menu_adm_opm_opciones_menu] FOREIGN KEY ([opm_opcion_padre]) REFERENCES [dbo].[adm_opm_opciones_menu] ([opm_codigo])
GO
GRANT SELECT ON  [dbo].[adm_opm_opciones_menu] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[adm_opm_opciones_menu] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[adm_opm_opciones_menu] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[adm_opm_opciones_menu] TO [APPUser]
GO
