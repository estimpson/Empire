CREATE TABLE [EEIUser].[WP_UpdateCsmDemand_EmpireFactor_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BasePart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MnemonicVehiclePlant] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TakeRate] [decimal] (20, 6) NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vehicle] [varchar] (510) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[QtyPer] [decimal] (20, 6) NULL,
[FamilyAllocation] [decimal] (20, 6) NULL,
[EmpireMarketSegment] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireApplication] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateStamp] [datetime] NULL,
[Notes] [datetime] NULL,
[Jan2015] [decimal] (20, 6) NULL,
[Feb2015] [decimal] (20, 6) NULL,
[Mar2015] [decimal] (20, 6) NULL,
[Apr2015] [decimal] (20, 6) NULL,
[May2015] [decimal] (20, 6) NULL,
[Jun2015] [decimal] (20, 6) NULL,
[Jul2015] [decimal] (20, 6) NULL,
[Aug2015] [decimal] (20, 6) NULL,
[Sep2015] [decimal] (20, 6) NULL,
[Oct2015] [decimal] (20, 6) NULL,
[Nov2015] [decimal] (20, 6) NULL,
[Dec2015] [decimal] (20, 6) NULL,
[Total2015] [decimal] (20, 6) NULL,
[Jan2016] [decimal] (20, 6) NULL,
[Feb2016] [decimal] (20, 6) NULL,
[Mar2016] [decimal] (20, 6) NULL,
[Apr2016] [decimal] (20, 6) NULL,
[May2016] [decimal] (20, 6) NULL,
[Jun2016] [decimal] (20, 6) NULL,
[Jul2016] [decimal] (20, 6) NULL,
[Aug2016] [decimal] (20, 6) NULL,
[Sep2016] [decimal] (20, 6) NULL,
[Oct2016] [decimal] (20, 6) NULL,
[Nov2016] [decimal] (20, 6) NULL,
[Dec2016] [decimal] (20, 6) NULL,
[Total2016] [decimal] (20, 6) NULL,
[Jan2017] [decimal] (20, 6) NULL,
[Feb2017] [decimal] (20, 6) NULL,
[Mar2017] [decimal] (20, 6) NULL,
[Apr2017] [decimal] (20, 6) NULL,
[May2017] [decimal] (20, 6) NULL,
[Jun2017] [decimal] (20, 6) NULL,
[Jul2017] [decimal] (20, 6) NULL,
[Aug2017] [decimal] (20, 6) NULL,
[Sep2017] [decimal] (20, 6) NULL,
[Oct2017] [decimal] (20, 6) NULL,
[Nov2017] [decimal] (20, 6) NULL,
[Dec2017] [decimal] (20, 6) NULL,
[Total2017] [decimal] (20, 6) NULL,
[Jan2018] [decimal] (20, 6) NULL,
[Feb2018] [decimal] (20, 6) NULL,
[Mar2018] [decimal] (20, 6) NULL,
[Apr2018] [decimal] (20, 6) NULL,
[May2018] [decimal] (20, 6) NULL,
[Jun2018] [decimal] (20, 6) NULL,
[Jul2018] [decimal] (20, 6) NULL,
[Aug2018] [decimal] (20, 6) NULL,
[Sep2018] [decimal] (20, 6) NULL,
[Oct2018] [decimal] (20, 6) NULL,
[Nov2018] [decimal] (20, 6) NULL,
[Dec2018] [decimal] (20, 6) NULL,
[Total2018] [decimal] (20, 6) NULL,
[Jan2019] [decimal] (20, 6) NULL,
[Feb2019] [decimal] (20, 6) NULL,
[Mar2019] [decimal] (20, 6) NULL,
[Apr2019] [decimal] (20, 6) NULL,
[May2019] [decimal] (20, 6) NULL,
[Jun2019] [decimal] (20, 6) NULL,
[Jul2019] [decimal] (20, 6) NULL,
[Aug2019] [decimal] (20, 6) NULL,
[Sep2019] [decimal] (20, 6) NULL,
[Oct2019] [decimal] (20, 6) NULL,
[Nov2019] [decimal] (20, 6) NULL,
[Dec2019] [decimal] (20, 6) NULL,
[Total2019] [decimal] (20, 6) NULL,
[Total2020] [decimal] (20, 6) NULL,
[Total2021] [decimal] (20, 6) NULL,
[Total2022] [decimal] (20, 6) NULL,
[Jan2015New] [decimal] (20, 6) NULL,
[Feb2015New] [decimal] (20, 6) NULL,
[Mar2015New] [decimal] (20, 6) NULL,
[Apr2015New] [decimal] (20, 6) NULL,
[May2015New] [decimal] (20, 6) NULL,
[Jun2015New] [decimal] (20, 6) NULL,
[Jul2015New] [decimal] (20, 6) NULL,
[Aug2015New] [decimal] (20, 6) NULL,
[Sep2015New] [decimal] (20, 6) NULL,
[Oct2015New] [decimal] (20, 6) NULL,
[Nov2015New] [decimal] (20, 6) NULL,
[Dec2015New] [decimal] (20, 6) NULL,
[Total2015New] [decimal] (20, 6) NULL,
[Jan2016New] [decimal] (20, 6) NULL,
[Feb2016New] [decimal] (20, 6) NULL,
[Mar2016New] [decimal] (20, 6) NULL,
[Apr2016New] [decimal] (20, 6) NULL,
[May2016New] [decimal] (20, 6) NULL,
[Jun2016New] [decimal] (20, 6) NULL,
[Jul2016New] [decimal] (20, 6) NULL,
[Aug2016New] [decimal] (20, 6) NULL,
[Sep2016New] [decimal] (20, 6) NULL,
[Oct2016New] [decimal] (20, 6) NULL,
[Nov2016New] [decimal] (20, 6) NULL,
[Dec2016New] [decimal] (20, 6) NULL,
[Total2016New] [decimal] (20, 6) NULL,
[Jan2017New] [decimal] (20, 6) NULL,
[Feb2017New] [decimal] (20, 6) NULL,
[Mar2017New] [decimal] (20, 6) NULL,
[Apr2017New] [decimal] (20, 6) NULL,
[May2017New] [decimal] (20, 6) NULL,
[Jun2017New] [decimal] (20, 6) NULL,
[Jul2017New] [decimal] (20, 6) NULL,
[Aug2017New] [decimal] (20, 6) NULL,
[Sep2017New] [decimal] (20, 6) NULL,
[Oct2017New] [decimal] (20, 6) NULL,
[Nov2017New] [decimal] (20, 6) NULL,
[Dec2017New] [decimal] (20, 6) NULL,
[Total2017New] [decimal] (20, 6) NULL,
[Jan2018New] [decimal] (20, 6) NULL,
[Feb2018New] [decimal] (20, 6) NULL,
[Mar2018New] [decimal] (20, 6) NULL,
[Apr2018New] [decimal] (20, 6) NULL,
[May2018New] [decimal] (20, 6) NULL,
[Jun2018New] [decimal] (20, 6) NULL,
[Jul2018New] [decimal] (20, 6) NULL,
[Aug2018New] [decimal] (20, 6) NULL,
[Sep2018New] [decimal] (20, 6) NULL,
[Oct2018New] [decimal] (20, 6) NULL,
[Nov2018New] [decimal] (20, 6) NULL,
[Dec2018New] [decimal] (20, 6) NULL,
[Total2018New] [decimal] (20, 6) NULL,
[Jan2019New] [decimal] (20, 6) NULL,
[Feb2019New] [decimal] (20, 6) NULL,
[Mar2019New] [decimal] (20, 6) NULL,
[Apr2019New] [decimal] (20, 6) NULL,
[May2019New] [decimal] (20, 6) NULL,
[Jun2019New] [decimal] (20, 6) NULL,
[Jul2019New] [decimal] (20, 6) NULL,
[Aug2019New] [decimal] (20, 6) NULL,
[Sep2019New] [decimal] (20, 6) NULL,
[Oct2019New] [decimal] (20, 6) NULL,
[Nov2019New] [decimal] (20, 6) NULL,
[Dec2019New] [decimal] (20, 6) NULL,
[Total2019New] [decimal] (20, 6) NULL,
[Total2020New] [decimal] (20, 6) NULL,
[Total2021New] [decimal] (20, 6) NULL,
[Total2022New] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[WP_UpdateCsmDemand_EmpireFactor_History] ADD CONSTRAINT [PK__WP_Updat__3214EC277C61812D] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
