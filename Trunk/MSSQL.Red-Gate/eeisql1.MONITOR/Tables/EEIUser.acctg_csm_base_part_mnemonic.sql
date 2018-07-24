CREATE TABLE [EEIUser].[acctg_csm_base_part_mnemonic]
(
[RELEASE_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FORECAST_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MNEMONIC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BASE_PART] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QTY_PER] [decimal] (10, 0) NULL,
[TAKE_RATE] [decimal] (10, 6) NULL,
[FAMILY_ALLOCATION] [decimal] (10, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_base_part_mnemonic] ADD CONSTRAINT [PK_acctg_csm_base_part_mnemonic2] PRIMARY KEY CLUSTERED  ([RELEASE_ID], [FORECAST_ID], [MNEMONIC], [BASE_PART]) ON [PRIMARY]
GO
