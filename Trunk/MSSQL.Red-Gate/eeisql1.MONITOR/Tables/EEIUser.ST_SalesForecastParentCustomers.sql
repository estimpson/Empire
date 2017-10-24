CREATE TABLE [EEIUser].[ST_SalesForecastParentCustomers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LightingStudyCustomer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SalesForecastParentCustomer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_SalesForecastParentCustomers] ADD CONSTRAINT [PK__ST_Sales__3214EC274C930C07] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
