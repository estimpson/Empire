CREATE TABLE [EEIUser].[acctg_csm_mid_model_raw]
(
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignParent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vehicle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sop] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Eop] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exterior] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interior] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engine] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transmission] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chassis] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suspension] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionNameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Brand] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
