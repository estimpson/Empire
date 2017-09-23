CREATE TABLE [EDINAL].[StagingPlanningHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingPl__Statu__608DB2D8] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingPla__Type__6181D711] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowCr__6275FB4A] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowCr__636A1F83] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowMo__645E43BC] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowMo__655267F5] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDINAL].[StagingPlanningHeaders] ADD CONSTRAINT [PK__StagingP__FFEE74507E531FE9] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
