CREATE TABLE [dbo].[edi_po_high_auth]
(
[po_number] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cumyear] [int] NOT NULL,
[high_fab_date] [datetime] NOT NULL,
[high_fab_auth] [numeric] (20, 6) NULL,
[high_raw_date] [datetime] NOT NULL,
[high_raw_auth] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_po_high_auth] ADD CONSTRAINT [PK__edi_po_high_auth__2F10007B] PRIMARY KEY CLUSTERED  ([po_number], [part], [cumyear]) ON [PRIMARY]
GO
