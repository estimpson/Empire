CREATE TABLE [dbo].[IHSCalendarDemand]
(
[EntryDT] [datetime] NULL,
[periodDT] [int] NULL,
[YearDT] [int] NULL,
[base_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvgDailyIHSDemand] [int] NULL,
[AvgDailyIHSDemandAccum] [int] NULL,
[AvgCustomerDemand] [int] NULL,
[AvgCustomerDemandAccum] [int] NULL,
[AvgCustomerShipHistoryCurrentYear] [int] NULL,
[AvgCustomerShipHistoryAccumCurrentYear] [int] NULL,
[AvgCustomerShipHistoryPriorYear] [int] NULL,
[AvgCustomerShipHistoryAccumPriorYear] [int] NULL,
[ActualCustomerDemand] [int] NULL,
[ActualCustomerDemandShipped] [int] NULL,
[ActualCustomerDemandPlusShipped] [int] NULL,
[ActualCustomerDemandAccum] [int] NULL,
[ActualCustomerDemandPlusShippedAccum] [int] NULL
) ON [PRIMARY]
GO
