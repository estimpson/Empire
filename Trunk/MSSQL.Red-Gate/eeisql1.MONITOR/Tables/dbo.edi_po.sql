CREATE TABLE [dbo].[edi_po]
(
[po_number] [int] NOT NULL,
[buyer_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dock_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firm_days] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_po] ADD CONSTRAINT [PK__edi_po__145C0A3F] PRIMARY KEY CLUSTERED  ([po_number]) ON [PRIMARY]
GO
