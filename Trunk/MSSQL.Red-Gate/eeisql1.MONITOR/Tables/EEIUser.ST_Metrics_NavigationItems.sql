CREATE TABLE [EEIUser].[ST_Metrics_NavigationItems]
(
[NavigationGroup] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NavigationItem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_Metrics_NavigationItems] ADD CONSTRAINT [PK_ST_Metrics_NavigationItems] PRIMARY KEY CLUSTERED  ([NavigationGroup], [NavigationItem], [Sequence]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_Metrics_NavigationItems] ADD CONSTRAINT [FK_ST_Metrics_NavigationItems_ST_Metrics_NavigationGroups] FOREIGN KEY ([NavigationGroup]) REFERENCES [EEIUser].[ST_Metrics_NavigationGroups] ([NavigationGroup]) ON UPDATE CASCADE
GO
