CREATE TABLE [EEIUser].[acctg_csm_BasePartCloseouts]
(
[BasePart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchedulerResponsible] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RfMpsLink] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchedulingTeamComments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaterialsComments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FgInventoryAfterBuildout] [decimal] (20, 6) NULL,
[CostEach] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcessFgAfterBuildout] [decimal] (20, 6) NULL,
[ExcessRmAfterBuildout] [decimal] (20, 6) NULL,
[ProgramExposure] [decimal] (20, 6) NULL,
[DateToSendCoLetter] [datetime] NULL,
[ObsolescenceCost] [decimal] (20, 6) NULL,
[Status] [int] NULL CONSTRAINT [DF__BasePartC__Statu__33345BA2] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__BasePartC__RowCr__34287FDB] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__BasePartC__RowCr__351CA414] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__BasePartC__RowMo__3610C84D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__BasePartC__RowMo__3704EC86] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_BasePartCloseouts] ADD CONSTRAINT [PK__BasePart__FFEE7451314C1330] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
