CREATE TABLE [dbo].[monitor_audit_trail_types]
(
[audit_trail_type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[audit_trail_type_description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[monitor_audit_trail_types] ADD CONSTRAINT [pk_monitor_audit_trail_types] PRIMARY KEY CLUSTERED  ([audit_trail_type]) ON [PRIMARY]
GO
