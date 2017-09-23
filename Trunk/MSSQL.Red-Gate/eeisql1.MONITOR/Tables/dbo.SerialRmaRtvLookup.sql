CREATE TABLE [dbo].[SerialRmaRtvLookup]
(
[RmaRtvNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Serial] [int] NOT NULL,
[GlSegment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__SerialRma__RowCr__068E9C25] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__SerialRma__RowCr__0782C05E] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__SerialRma__RowMo__0876E497] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__SerialRma__RowMo__096B08D0] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialRmaRtvLookup] ADD CONSTRAINT [PK__SerialRm__FFEE745104A653B3] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialRmaRtvLookup] ADD CONSTRAINT [FK_SerialRmaRtvLookup_SerialRmaRtvLookupTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[SerialRmaRtvLookupTypes] ([TransactionType])
GO
