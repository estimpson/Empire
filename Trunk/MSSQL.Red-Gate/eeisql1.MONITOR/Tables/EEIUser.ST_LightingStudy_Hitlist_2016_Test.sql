CREATE TABLE [EEIUser].[ST_LightingStudy_Hitlist_2016_Test]
(
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EstYearlySales] [int] NULL,
[PeakYearlyVolume] [int] NULL,
[SOPYear] [int] NULL,
[LED/Harness] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Component] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [decimal] (10, 2) NULL,
[Volume2017] [int] NULL,
[Volume2018] [int] NULL,
[Volume2019] [int] NULL,
[Volume2020] [int] NULL,
[Volume2021] [int] NULL,
[Volume2022] [int] NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AwardedVolume] [int] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_LightingStudy_Hitlist_2016_Test] ADD CONSTRAINT [PK__ST_FASTT__3214EC276105AFB7] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
