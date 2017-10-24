CREATE TABLE [EEIUser].[ST_CombinedLighting]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[VehiclePlantMnemonic] [int] NULL,
[Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionBrand] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sop] [datetime2] NULL,
[BulbType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ComponentVolume2017] [int] NULL,
[ComponentVolume2018] [int] NULL,
[ComponentVolume2019] [int] NULL,
[ComponentVolume2020] [int] NULL,
[ComponentVolume2021] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_CombinedLighting] ADD CONSTRAINT [PK_ST_CombinedLighting] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
