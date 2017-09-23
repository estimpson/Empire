CREATE TABLE [EEIUser].[QT_Requote]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_Requote] ADD CONSTRAINT [PK__Requote__3214EC277617DDD5] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
