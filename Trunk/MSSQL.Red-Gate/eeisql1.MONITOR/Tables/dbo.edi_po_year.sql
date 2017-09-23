CREATE TABLE [dbo].[edi_po_year]
(
[po_number] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[year] [int] NOT NULL,
[cum_adjust] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_po_year] ADD CONSTRAINT [PK__edi_po_year__34C8D9D1] PRIMARY KEY CLUSTERED  ([po_number], [part], [year]) ON [PRIMARY]
GO
