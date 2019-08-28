CREATE TABLE [EEIUser].[OBS_acctg_csm_study_CHIMSEL]
(
[forecast_id] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[mnemonic] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[component_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supplier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[units] [int] NULL,
[footnote] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[OBS_acctg_csm_study_CHIMSEL] ADD CONSTRAINT [PK_acctg_csm_CHIMSEL] PRIMARY KEY CLUSTERED  ([forecast_id], [version], [mnemonic], [type], [supplier]) ON [PRIMARY]
GO
