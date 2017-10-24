CREATE TABLE [Audit].[DataChanges]
(
[ConnectionID] [uniqueidentifier] NULL,
[TransactionID] [bigint] NULL,
[TableName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldData] [xml] NULL,
[NewData] [xml] NULL,
[ConnectionInfo] [xml] NULL,
[SessionInfo] [xml] NULL,
[TransactionInfo] [xml] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__DataChang__RowCr__2EA21CE0] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__DataChang__RowMo__2F964119] DEFAULT (getdate()),
[RowTS] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Audit].[DataChanges] ADD CONSTRAINT [PK__DataChan__FFEE74512CB9D46E] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
