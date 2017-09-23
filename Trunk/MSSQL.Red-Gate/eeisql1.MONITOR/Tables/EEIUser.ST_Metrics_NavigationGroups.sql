CREATE TABLE [EEIUser].[ST_Metrics_NavigationGroups]
(
[NavigationGroup] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_Metrics_NavigationGroups] ADD CONSTRAINT [PK__ST_Metri__09EEDEBA4CACE2D9] PRIMARY KEY CLUSTERED  ([NavigationGroup]) ON [PRIMARY]
GO
