CREATE TABLE [dbo].[SerialRmaRtvLookupTypes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TransactionType] [int] NOT NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialRmaRtvLookupTypes] ADD CONSTRAINT [uc_TransactionType] UNIQUE NONCLUSTERED  ([TransactionType]) ON [PRIMARY]
GO
