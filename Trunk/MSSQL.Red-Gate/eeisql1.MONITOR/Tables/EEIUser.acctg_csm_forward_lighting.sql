CREATE TABLE [EEIUser].[acctg_csm_forward_lighting]
(
[Component] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forecast Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Region] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Manufacturer Group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Production Brand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Production Nameplate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Platform] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Program] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: SOP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: EOP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VP: Global Sales Segment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Low Beam Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LED Headlamp Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: DBL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: AFS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: ADB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Adaptive Function: AHB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Low & High Beam Bulb Count] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp High Beam Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FBL Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp ADB Actuation Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Power Consumption (Watts)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Camera Fitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Camera Lighting Functions] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Units Camera] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motor Fitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motor Units] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Indicator Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Fitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Implementation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRL Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Fog Fitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Front Fog Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FBL Fitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier Group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier Region] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Supplier Plant] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headlamp Units] [decimal] (18, 0) NULL,
[Vehicle Units] [decimal] (18, 0) NULL,
[Component Volume 2017] [decimal] (18, 0) NULL,
[Component Volume 2018] [decimal] (18, 0) NULL,
[Component Volume 2019] [decimal] (18, 0) NULL,
[Component Volume 2020] [decimal] (18, 0) NULL,
[Component Volume 2021] [decimal] (18, 0) NULL,
[Component Volume 2022] [decimal] (18, 0) NULL,
[Component Volume 2023] [decimal] (18, 0) NULL,
[Component Volume 2024] [decimal] (18, 0) NULL,
[Vehicle Volume 2017] [decimal] (18, 0) NULL,
[Vehicle Volume 2018] [decimal] (18, 0) NULL,
[Vehicle Volume 2019] [decimal] (18, 0) NULL,
[Vehicle Volume 2020] [decimal] (18, 0) NULL,
[Vehicle Volume 2021] [decimal] (18, 0) NULL,
[Vehicle Volume 2022] [decimal] (18, 0) NULL,
[Vehicle Volume 2023] [decimal] (18, 0) NULL,
[Vehicle Volume 2024] [decimal] (18, 0) NULL
) ON [PRIMARY]
GO
