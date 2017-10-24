CREATE TABLE [EEIUser].[acctg_csm_material_cost_tabular_temp]
(
[FORECAST_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VERSION] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BASE_PART] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EFFECTIVE_DATE] [datetime] NULL,
[COST] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_material_cost_tabular_temp] ADD CONSTRAINT [PK_acctg_csm_material_cost_tabular_temp] PRIMARY KEY CLUSTERED  ([FORECAST_ID], [VERSION], [BASE_PART]) ON [PRIMARY]
GO
