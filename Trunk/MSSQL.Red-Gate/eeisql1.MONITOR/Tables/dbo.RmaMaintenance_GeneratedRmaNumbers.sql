CREATE TABLE [dbo].[RmaMaintenance_GeneratedRmaNumbers]
(
[RmaNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__RmaMainte__RowCr__0DD6F149] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__RmaMainte__RowCr__0ECB1582] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__RmaMainte__RowMo__0FBF39BB] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__RmaMainte__RowMo__10B35DF4] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RmaMaintenance_GeneratedRmaNumbers] ADD CONSTRAINT [PK__RmaMaint__FFEE74510BEEA8D7] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
