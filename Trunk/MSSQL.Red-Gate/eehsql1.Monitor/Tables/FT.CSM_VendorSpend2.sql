CREATE TABLE [FT].[CSM_VendorSpend2]
(
[base_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Badge] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CSM_eop_display] [datetime] NULL,
[Total_2011_Totaldemand] [numeric] (38, 6) NULL,
[Total_2012_Totaldemand] [numeric] (38, 6) NULL,
[FGDemand2013] [numeric] (38, 6) NULL,
[FGDemand2014] [numeric] (38, 6) NULL,
[FGDemand2015] [numeric] (38, 6) NULL,
[FGDemand2016] [numeric] (38, 6) NULL,
[FGDemand2017] [numeric] (38, 6) NULL,
[FGDemand2018] [numeric] (38, 6) NULL,
[FGDemand2019] [numeric] (38, 6) NULL,
[FGDemand2020] [numeric] (38, 6) NULL,
[FGDemand2021] [numeric] (38, 6) NULL,
[RawPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Commodity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyPer] [numeric] (20, 6) NULL,
[RawPartDemand2011] [numeric] (38, 6) NULL,
[RawPartDemand2012] [numeric] (38, 6) NULL,
[RawPartDemand2013] [numeric] (38, 6) NULL,
[RawPartDemand2014] [numeric] (38, 6) NULL,
[RawPartDemand2015] [numeric] (38, 6) NULL,
[RawPartDemand2016] [numeric] (38, 6) NULL,
[RawPartSpend2011] [numeric] (38, 6) NULL,
[RawPartSpend2012] [numeric] (38, 6) NULL,
[RawPartSpend2013] [numeric] (38, 6) NULL,
[RawPartSpend2014] [numeric] (38, 6) NULL,
[RawPartSpend2015] [numeric] (38, 6) NULL,
[RawPartSpend2016] [numeric] (38, 6) NULL,
[RawPartSpend2017] [numeric] (38, 6) NULL,
[RawPartSpend2018] [numeric] (38, 6) NULL,
[RawPartSpend2019] [numeric] (38, 6) NULL,
[RawPartSpend2020] [numeric] (38, 6) NULL,
[RawPartSpend2021] [numeric] (38, 6) NULL,
[default_vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standard_pack] [numeric] (20, 6) NULL,
[LeadTime] [numeric] (22, 8) NOT NULL,
[StandardCost] [numeric] (20, 6) NULL,
[LeadTimeFlag] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaxCSMEOPforRawPart] [datetime] NULL,
[AllRawPartInventory] [numeric] (38, 6) NULL,
[VendorTerms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO