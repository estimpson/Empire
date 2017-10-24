CREATE TABLE [EEIUser].[acctg_inv_std_hours]
(
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[period] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[std_hours] [decimal] (10, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_inv_std_hours] ADD CONSTRAINT [PK_acctg_inv_std_hours] PRIMARY KEY CLUSTERED  ([fiscal_year], [period], [part]) ON [PRIMARY]
GO
