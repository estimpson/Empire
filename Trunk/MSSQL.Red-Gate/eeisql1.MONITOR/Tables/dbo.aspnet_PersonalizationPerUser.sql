CREATE TABLE [dbo].[aspnet_PersonalizationPerUser]
(
[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF__aspnet_Perso__Id__67699A01] DEFAULT (newid()),
[PathId] [uniqueidentifier] NULL,
[UserId] [uniqueidentifier] NULL,
[PageSettings] [image] NOT NULL,
[LastUpdatedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD CONSTRAINT [PK__aspnet_P__3214EC066581518F] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_PersonalizationPerUser_index1] ON [dbo].[aspnet_PersonalizationPerUser] ([PathId], [UserId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [aspnet_PersonalizationPerUser_ncindex2] ON [dbo].[aspnet_PersonalizationPerUser] ([UserId], [PathId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD CONSTRAINT [FK__aspnet_Pe__PathI__685DBE3A] FOREIGN KEY ([PathId]) REFERENCES [dbo].[aspnet_Paths] ([PathId])
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD CONSTRAINT [FK__aspnet_Pe__UserI__6951E273] FOREIGN KEY ([UserId]) REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
