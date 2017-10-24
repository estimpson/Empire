CREATE TABLE [EEIUser].[acctg_csm_study_NACTD]
(
[release_id] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vehicle] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Design_Lead] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Lead_State] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Lead_Country] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary_Design_Lead] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary_Lead_Territory] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary_Lead_Country] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ST_Risk_Level] [decimal] (5, 2) NULL,
[LT_Risk_Level] [decimal] (5, 2) NULL,
[Vehicle_Lifecycle_Months] [decimal] (10, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_study_NACTD] ADD CONSTRAINT [PK_acctg_csm_NACTD] PRIMARY KEY CLUSTERED  ([release_id], [Mnemonic]) ON [PRIMARY]
GO
