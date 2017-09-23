CREATE TABLE [dbo].[trwserials]
(
[serial] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[trwserials] ADD CONSTRAINT [intserialpk] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
