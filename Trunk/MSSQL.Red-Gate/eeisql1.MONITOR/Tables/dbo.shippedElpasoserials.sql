CREATE TABLE [dbo].[shippedElpasoserials]
(
[serial] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[shippedElpasoserials] ADD CONSTRAINT [elpasoserials20080116_x] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
