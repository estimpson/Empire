CREATE TABLE [dbo].[ee_accounts_receivable]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[company_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[distribution_list] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ee_accounts_receivable] ADD CONSTRAINT [PK_ee_accounts_receivable] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
