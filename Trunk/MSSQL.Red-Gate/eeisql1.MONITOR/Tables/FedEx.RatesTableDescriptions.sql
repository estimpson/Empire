CREATE TABLE [FedEx].[RatesTableDescriptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[RatesTableDescriptions] ADD CONSTRAINT [PK_RatesTableDescID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
