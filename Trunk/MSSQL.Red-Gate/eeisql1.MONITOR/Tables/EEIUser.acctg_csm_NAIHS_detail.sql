CREATE TABLE [EEIUser].[acctg_csm_NAIHS_detail]
(
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mnemonic-Vehicle/Plant] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EffectiveYear] [int] NOT NULL,
[EffectiveDT] [datetime] NULL,
[SalesDemand] [decimal] (10, 2) NULL,
[Header_ID] [int] NOT NULL,
[Period] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_NAIHS_detail] ADD CONSTRAINT [PK__acctg_cs__9E9692CD7C598B98] PRIMARY KEY CLUSTERED  ([Header_ID], [EffectiveYear], [Period]) ON [PRIMARY]
GO
