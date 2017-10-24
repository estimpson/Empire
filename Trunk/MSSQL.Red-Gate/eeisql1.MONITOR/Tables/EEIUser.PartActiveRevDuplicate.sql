CREATE TABLE [EEIUser].[PartActiveRevDuplicate]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rev] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[PartActiveRevDuplicate] ADD CONSTRAINT [partyyyy] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
