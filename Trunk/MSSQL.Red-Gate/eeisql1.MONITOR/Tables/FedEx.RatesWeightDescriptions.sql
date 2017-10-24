CREATE TABLE [FedEx].[RatesWeightDescriptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Weight] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[RatesWeightDescriptions] ADD CONSTRAINT [PK_RatesWeightDescID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
