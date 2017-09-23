CREATE TABLE [dbo].[serialstoscrap]
(
[serial] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[serialstoscrap] ADD CONSTRAINT [PK_serialstoscrap] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
