CREATE TABLE [dbo].[account_code]
(
[account_no] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[account_code] ADD CONSTRAINT [PK__account_code__1F2E9E6D] PRIMARY KEY CLUSTERED  ([account_no]) ON [PRIMARY]
GO
