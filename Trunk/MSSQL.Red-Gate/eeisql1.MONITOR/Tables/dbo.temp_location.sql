CREATE TABLE [dbo].[temp_location]
(
[locationcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_location] ADD CONSTRAINT [PK_temp_location] PRIMARY KEY CLUSTERED  ([locationcode]) ON [PRIMARY]
GO
