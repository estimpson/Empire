CREATE TABLE [EDICHRY].[StagingShipScheduleHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingSh__Statu__523E9A8F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingShi__Type__5332BEC8] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowCr__5426E301] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowCr__551B073A] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowMo__560F2B73] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowMo__57034FAC] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDICHRY].[StagingShipScheduleHeaders] ADD CONSTRAINT [PK__StagingS__FFEE745062AA0C82] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
