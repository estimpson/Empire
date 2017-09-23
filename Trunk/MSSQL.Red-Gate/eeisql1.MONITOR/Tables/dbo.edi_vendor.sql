CREATE TABLE [dbo].[edi_vendor]
(
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trading_partner_code] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[total_weeks] [int] NULL,
[raw_auth_weeks] [int] NULL,
[auto_create_po] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[send_days] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_vendor] ADD CONSTRAINT [PK__edi_vendor__0BC6C43E] PRIMARY KEY CLUSTERED  ([vendor]) ON [PRIMARY]
GO
