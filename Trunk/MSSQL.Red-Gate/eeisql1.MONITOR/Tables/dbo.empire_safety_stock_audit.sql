CREATE TABLE [dbo].[empire_safety_stock_audit]
(
[item] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[safety_stock_audit_identity] [int] NOT NULL IDENTITY(1, 1),
[old_safety_stock] [decimal] (18, 6) NULL,
[new_safety_stock] [decimal] (18, 6) NULL,
[change_authorized_by] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[change_reason] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[empire_safety_stock_audit] ADD CONSTRAINT [pk_empire_safety_stock_audit] PRIMARY KEY CLUSTERED  ([item], [location], [safety_stock_audit_identity]) ON [PRIMARY]
GO
