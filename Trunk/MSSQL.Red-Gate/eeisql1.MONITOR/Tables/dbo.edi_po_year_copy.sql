CREATE TABLE [dbo].[edi_po_year_copy]
(
[po_number] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[year] [int] NOT NULL,
[cum_adjust] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_po_year_copy] ADD CONSTRAINT [PK__edi_po_year_copy__440B1D61] PRIMARY KEY CLUSTERED  ([po_number], [part], [year]) ON [PRIMARY]
GO
