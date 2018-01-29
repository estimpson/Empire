CREATE TABLE [EEIUser].[acctg_csm_base_part_mnemonic_OBS]
(
[FORECAST_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MNEMONIC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BASE_PART] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FAMILY] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMPIRE_MARKET_SEGMENT] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMPIRE_APPLICATION] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QTY_PER] [decimal] (10, 0) NULL,
[TAKE_RATE] [decimal] (10, 6) NULL,
[FAMILY_ALLOCATION] [decimal] (10, 6) NULL,
[EMPIRE_SOP] [smalldatetime] NULL,
[EMPIRE_EOP] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_base_part_mnemonic_OBS] ADD CONSTRAINT [PK_acctg_csm_base_part_mnemonic] PRIMARY KEY CLUSTERED  ([FORECAST_ID], [MNEMONIC], [BASE_PART]) ON [PRIMARY]
GO
