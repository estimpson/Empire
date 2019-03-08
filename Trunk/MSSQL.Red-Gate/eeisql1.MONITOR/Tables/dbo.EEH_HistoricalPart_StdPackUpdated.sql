CREATE TABLE [dbo].[EEH_HistoricalPart_StdPackUpdated]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[standard_pack_eeh] [numeric] (20, 6) NOT NULL,
[standard_pack_eei] [numeric] (20, 6) NOT NULL,
[RegDT] [datetime] NOT NULL CONSTRAINT [DF_EEH_HistoricalPart_StdPackUpdated_RegDT] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EEH_HistoricalPart_StdPackUpdated] ADD CONSTRAINT [PK_EEH_HistoricalPart_StdPackUpdated] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
