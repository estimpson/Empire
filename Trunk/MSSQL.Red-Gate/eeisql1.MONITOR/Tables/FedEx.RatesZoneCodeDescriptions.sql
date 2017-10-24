CREATE TABLE [FedEx].[RatesZoneCodeDescriptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ZoneCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[RatesZoneCodeDescriptions] ADD CONSTRAINT [PK_RatesZoneCodeDescID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
