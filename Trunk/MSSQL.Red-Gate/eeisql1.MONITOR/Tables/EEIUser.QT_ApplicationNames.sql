CREATE TABLE [EEIUser].[QT_ApplicationNames]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_ApplicationNames] ADD CONSTRAINT [PK__QT_Appli__3214EC277741D78F] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_ApplicationNames] ADD CONSTRAINT [UQ__QT_Appli__309103317A1E443A] UNIQUE NONCLUSTERED  ([ApplicationName]) ON [PRIMARY]
GO
