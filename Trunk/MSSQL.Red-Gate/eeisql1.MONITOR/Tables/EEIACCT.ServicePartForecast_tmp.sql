CREATE TABLE [EEIACCT].[ServicePartForecast_tmp]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartNumber] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndOfServiceYear] [int] NULL,
[Scheduler] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active2011Demand] [int] NULL,
[Active2012Demand] [int] NULL,
[Shipped2011Demand] [int] NULL,
[ServiceDemand2012] [int] NULL,
[ServiceDemand2013] [int] NULL,
[ServiceDemand2014] [int] NULL,
[ServiceDemand2015] [int] NULL,
[ServiceDemand2016] [int] NULL,
[ServiceDemand2017] [int] NULL,
[ServiceDemand2018] [int] NULL,
[ServiceDemand2019] [int] NULL,
[ServiceDemand2020] [int] NULL,
[ServiceDemand2021] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[ServicePartForecast_tmp] ADD CONSTRAINT [PK__ServiceP__A91CCA10649683A0] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
