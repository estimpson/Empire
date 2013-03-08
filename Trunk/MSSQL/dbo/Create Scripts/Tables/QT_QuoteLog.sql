USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_QuoteLog]    Script Date: 03/04/2013 11:39:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EEIUser].[QT_QuoteLog](
	[QuoteNumber] [varchar](50) NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[ParentQuoteID] [int] NULL,
	[CustomerRFQNumber] [varchar](50) NULL,
	[ReceiptDate] [datetime] NULL,
	[Customer] [varchar](50) NULL,
	[RequestedDueDate] [datetime] NULL,
	[EEIPromisedDueDate] [datetime] NULL,
	[CustomerPartNumber] [varchar](50) NULL,
	[EEIPartNumber] [varchar](50) NULL,
	[Requote] [char](2) NULL,
	[Notes] [varchar](max) NULL,
	[EAU] [numeric](20, 6) NULL,
	[ApplicationName] [varchar](255) NULL,
	[ApplicationCode] [varchar](10) NULL,
	[FunctionName] [varchar](50) NULL,
	[Program] [varchar](50) NULL,
	[OEM] [varchar](50) NULL,
	[Nameplate] [varchar](50) NULL,
	[ModelYear] [varchar](10) NULL,
	[SOP] [varchar](10) NULL,
	[EOP] [varchar](10) NULL,
	[SalesInitials] [varchar](10) NULL,
	[ProgramManagerInitials] [varchar](10) NULL,
	[EngineeringInitials] [varchar](10) NULL,
	[LTAPercentage] [varchar](10) NULL,
	[LTAYears] [varchar](10) NULL,
	[EngineeringMaterialsInitials] [varchar](10) NULL,
	[EngineeringMaterialsDate] [datetime] NULL,
	[QuoteReviewInitials] [varchar](10) NULL,
	[QuoteReviewDate] [datetime] NULL,
	[QuotePricingInitials] [varchar](10) NULL,
	[QuotePricingDate] [datetime] NULL,
	[CustomerQuoteInitials] [varchar](10) NULL,
	[CustomerQuoteDate] [datetime] NULL,
	[StraightMaterialCost] [numeric](20, 6) NULL,
	[QuotePrice] [numeric](20, 6) NULL,
	[TotalQuotedSales]  AS ([QuotePrice]*[EAU]),
	[QuoteStatus] [varchar](10) NULL,
	[Awarded] [char](3) NULL,
	[ProductionLevel] [char](3) NULL,
	[RevLevel] [varchar](50) NULL,
	[ProductionMaterialRollup] [numeric](20, 6) NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[RowCreateDT] [datetime] NULL,
	[RowCreateUser] [sysname] NOT NULL,
	[RowModifiedDT] [datetime] NULL,
	[RowModifiedUser] [sysname] NOT NULL,
	[Tooling] [numeric](20, 6) NULL,
	[ProgramComputed]  AS ([EEIUser].[fn_QT_GetCSMProgramsForQuote]([QuoteNumber])),
	[OEMComputed]  AS ([EEIUser].[fn_QT_GetCSMManufacturersForQuote]([QuoteNumber])),
	[NameplateComputed]  AS ([EEIUser].[fn_QT_GetCSMNameplatesForQuote]([QuoteNumber])),
	[PrototypePrice] [numeric](20, 6) NULL,
PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[QuoteNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EEIUser].[QT_QuoteLog]  WITH CHECK ADD FOREIGN KEY([ParentQuoteID])
REFERENCES [EEIUser].[QT_QuoteLog] ([RowID])
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT (getdate()) FOR [RowCreateDT]
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT (suser_name()) FOR [RowCreateUser]
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT (getdate()) FOR [RowModifiedDT]
GO

ALTER TABLE [EEIUser].[QT_QuoteLog] ADD  DEFAULT (suser_name()) FOR [RowModifiedUser]
GO

