drop table eeiuser.acctg_csm_vpvp

create TABLE [EEIUser].[acctg_csm_VPVP]
(
[Region] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DesignParent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SOP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EOP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangeDate] [datetime] NOT NULL,
[ChangeType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__acctg_csm__RowCr__32931118] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__acctg_csm__RowCr__33873551] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__acctg_csm__RowMo__347B598A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__acctg_csm__RowMo__356F7DC3] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_VPVP] ADD CONSTRAINT [PK__acctg_cs__FFEE74512DCE5BFB] PRIMARY KEY CLUSTERED ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_VPVP] drop CONSTRAINT [UQ__acctg_cs__D3C7740730AAC8A6] UNIQUE NONCLUSTERED ([Region]) ON [PRIMARY]
GO

alter table [EEIUser].[acctg_csm_VPVP] alter column SOP varchar(255)
