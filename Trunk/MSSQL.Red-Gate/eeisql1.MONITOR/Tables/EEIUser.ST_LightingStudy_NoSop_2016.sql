CREATE TABLE [EEIUser].[ST_LightingStudy_NoSop_2016]
(
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[BulbType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NamePlate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Label] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Volume2017] [int] NULL,
[Volume2018] [int] NULL,
[Volume2019] [int] NULL,
[PeakVolume] [int] NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_LightingStudy_NoSop_2016] ADD CONSTRAINT [PK_ST_LightingStudy_2016] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
