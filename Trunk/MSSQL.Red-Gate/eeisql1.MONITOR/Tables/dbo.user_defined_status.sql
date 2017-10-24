CREATE TABLE [dbo].[user_defined_status]
(
[display_name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[base] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[user_defined_status] ADD CONSTRAINT [PK__user_defined_sta__1CBC4616] PRIMARY KEY CLUSTERED  ([display_name]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[user_defined_status] TO [APPUser]
GO
