CREATE TABLE [dbo].[acctg_nal_pricing]
(
[customer_part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [decimal] (18, 6) NULL,
[comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[acctg_nal_pricing] ADD CONSTRAINT [customer_part] PRIMARY KEY CLUSTERED  ([customer_part]) ON [PRIMARY]
GO
