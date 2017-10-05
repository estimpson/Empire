CREATE TABLE [EEIUser].[acctg_csm_import_quote_material_cost]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaterialCost] [numeric] (20, 6) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_import_quote_material_cost] ADD CONSTRAINT [PK__acctg_cs__FFEE74510126364A] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
