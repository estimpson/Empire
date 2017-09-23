CREATE TABLE [dbo].[edi_po_temp_hc]
(
[po_number] [int] NOT NULL,
[buyer_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dock_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firm_days] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_po_temp_hc] ADD CONSTRAINT [PK__edi_po_temp_hc__29572725] PRIMARY KEY CLUSTERED  ([po_number]) ON [PRIMARY]
GO
