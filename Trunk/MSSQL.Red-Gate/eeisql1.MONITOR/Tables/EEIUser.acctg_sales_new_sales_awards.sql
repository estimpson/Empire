CREATE TABLE [EEIUser].[acctg_sales_new_sales_awards]
(
[ID] [float] NULL,
[Salesman] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program Manager] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date of Program Award] [datetime] NULL,
[Form of Customer Commitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date Added to MSF] [datetime] NULL,
[Quote Transfer Meeting Held] [datetime] NULL,
[Customer Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Part Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Empire Part Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New Business Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Replacing Empire Part Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vehicle Program] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vehicle Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP Date] [datetime] NULL,
[EOP Date] [datetime] NULL,
[Application] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product Line] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Empire Market Segment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Empire Market SubSegment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Geographic Market] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qty Per Vehicle] [float] NULL,
[Take Rate] [float] NULL,
[Family Allocation] [float] NULL,
[CSM EAU ] [float] NULL,
[Customer Annual Capacity Planning Volume] [float] NULL,
[Quote Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Date] [datetime] NULL,
[Quoted EAU] [float] NULL,
[MOQ] [float] NULL,
[Quoted Selling Price] [float] NULL,
[Quoted Material Cost] [float] NULL,
[Quoted Annual Sales] [float] NULL,
[Quoted LTA Commitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2013 Selling Price (LTA)] [float] NULL,
[2014 Selling Price (LTA)] [float] NULL,
[2015 Selling Price (LTA)] [float] NULL,
[2016 Selling Price (LTA)] [float] NULL,
[2017 Selling Price (LTA)] [float] NULL,
[2018 Selling Price (LTA)] [float] NULL,
[2019 Selling Price (LTA)] [float] NULL,
[2020 Selling Price (LTA)] [float] NULL,
[2021 Selling Price (LTA)] [float] NULL,
[2022 Selling Price (LTA)] [float] NULL,
[2023 Selling Price (LTA)] [float] NULL,
[2024 Selling Price (LTA)] [float] NULL,
[Customer Production PO Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date of Production PO] [datetime] NULL,
[PO Selling Price] [float] NULL,
[Quote vs PO Selling Price Variance] [float] NULL,
[Tooling PO Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date of Tooling PO] [datetime] NULL,
[Amount of Tooling PO] [float] NULL,
[Crimp die PO] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amortization] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Billing Trigger and Installments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tooling Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Budget Capex ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Empire Ship From Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Freight Terms] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Ship To Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
