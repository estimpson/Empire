CREATE TABLE [EEIUser].[WP_SalesForecastSummaries_Filter]
(
[Filter] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__WP_SalesF__Statu__0F08AA9F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__WP_SalesFo__Type__0FFCCED8] DEFAULT ((0)),
[Sequence] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__WP_SalesF__RowCr__10F0F311] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WP_SalesF__RowCr__11E5174A] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__WP_SalesF__RowMo__12D93B83] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WP_SalesF__RowMo__13CD5FBC] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[WP_SalesForecastSummaries_Filter] ADD CONSTRAINT [PK_WP_SalesForecastSummaries_Filter] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[WP_SalesForecastSummaries_Filter] ADD CONSTRAINT [WP_Sales_Filter] UNIQUE NONCLUSTERED  ([Filter]) ON [PRIMARY]
GO
