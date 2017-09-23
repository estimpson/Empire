CREATE TABLE [dbo].[Temp_HTS]
(
[Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Temp_HTS] ADD CONSTRAINT [PK_Temp_HTS] PRIMARY KEY CLUSTERED  ([Description]) ON [PRIMARY]
GO
