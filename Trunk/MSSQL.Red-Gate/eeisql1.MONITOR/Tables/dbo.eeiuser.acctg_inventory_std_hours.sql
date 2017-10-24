CREATE TABLE [dbo].[eeiuser.acctg_inventory_std_hours]
(
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[std_hours] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[eeiuser.acctg_inventory_std_hours] ADD CONSTRAINT [PK_eeiuser.acctg_inventory_std_hours] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
