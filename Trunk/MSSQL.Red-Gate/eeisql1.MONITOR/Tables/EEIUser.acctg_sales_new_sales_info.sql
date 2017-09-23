CREATE TABLE [EEIUser].[acctg_sales_new_sales_info]
(
[id] [int] NOT NULL,
[SalesPerson] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramManager] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofProgramAward] [datetime] NULL,
[FormofCustomerCommittment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAddedtoMSF] [datetime] NULL,
[CustomerCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpirePartNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplacingEmpirePartNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPartNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Family] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VehicleProgram] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VehicleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireMarketNiche] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireMarketSubNiche] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductLine] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeographicMarket] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyPerVehicle] [decimal] (18, 6) NULL,
[TakeRate] [decimal] (18, 6) NULL,
[FamilyAllocation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSMEAU] [decimal] (18, 6) NULL,
[QuoteDate] [datetime] NULL,
[QuoteNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuotedEAU] [decimal] (18, 6) NULL,
[MOQRequirement] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuotedSellingPrice] [decimal] (18, 6) NULL,
[QuotedMaterialCost] [decimal] (18, 6) NULL,
[QuotedAnnualSales] [decimal] (18, 6) NULL,
[QuotedLTACommitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellingPrice2013] [decimal] (18, 6) NULL,
[SellingPrice2014] [decimal] (18, 6) NULL,
[SellingPrice2015] [decimal] (18, 6) NULL,
[SellingPrice2016] [decimal] (18, 6) NULL,
[SellingPrice2017] [decimal] (18, 6) NULL,
[SellingPrice2018] [decimal] (18, 6) NULL,
[SellingPrice2019] [decimal] (18, 6) NULL,
[DateofProductionPO] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerProductionPO#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternativeCustomerCommitment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POSellingPrice] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireSOPDate] [datetime] NULL,
[EmpireEOPDate] [datetime] NULL,
[QuotevsPOSellingPriceVariance] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofToolingPO] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerToolingPO] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountofToolingPO] [decimal] (18, 6) NULL,
[CrimpdiePO] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amortization] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingTriggerandInstallments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapexBudgetID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireFacility] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTerms] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerShipTo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment3] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment4] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_sales_new_sales_info] ADD CONSTRAINT [PK_Acctg_Sales_New_Sales_Info] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
