CREATE TABLE [dbo].[edi_vendor_send_list]
(
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_vendor_send_list] ADD CONSTRAINT [PK__edi_vendor_send___09DE7BCC] PRIMARY KEY CLUSTERED  ([vendor]) ON [PRIMARY]
GO
