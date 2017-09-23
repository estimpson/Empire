CREATE TABLE [EEIUser].[ST_SalesLeadLog_StatusDefinition]
(
[StatusType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusValue] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_SalesLeadLog_StatusDefinition] ADD CONSTRAINT [PK__ST_Sales__AA2EC4A220323980] PRIMARY KEY CLUSTERED  ([StatusType]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_SalesLeadLog_StatusDefinition] ADD CONSTRAINT [uc_TypeVal] UNIQUE NONCLUSTERED  ([StatusType], [StatusValue]) ON [PRIMARY]
GO
