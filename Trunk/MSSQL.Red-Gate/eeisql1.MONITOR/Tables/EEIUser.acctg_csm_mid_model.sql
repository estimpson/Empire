CREATE TABLE [EEIUser].[acctg_csm_mid_model]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Region] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DesignParent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vehicle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sop] [datetime] NULL,
[Eop] [datetime] NULL,
[ChangeDate] [datetime] NULL,
[ChangeType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Exterior] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interior] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engine] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transmission] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chassis] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suspension] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionNameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Brand] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreateDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_mid_model] ADD CONSTRAINT [PK_acctg_csm_mid_model] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
