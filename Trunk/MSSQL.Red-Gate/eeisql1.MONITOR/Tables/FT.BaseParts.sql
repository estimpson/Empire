CREATE TABLE [FT].[BaseParts]
(
[GUID] [uniqueidentifier] NULL CONSTRAINT [DF__BaseParts__GUID__6399A2AA] DEFAULT (newid()),
[ID] [int] NOT NULL IDENTITY(1, 1),
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[BaseParts] ADD CONSTRAINT [PK__BaseParts__62A57E71] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
