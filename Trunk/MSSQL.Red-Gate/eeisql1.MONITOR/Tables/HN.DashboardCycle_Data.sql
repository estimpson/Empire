CREATE TABLE [HN].[DashboardCycle_Data]
(
[WeekInYear] [int] NULL,
[Date_Stamp] [datetime] NULL,
[Serial] [int] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[To_Loc] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[from_loc] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentLocation] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeG] [bit] NULL,
[TypeH] [bit] NULL,
[TypeShipout] [bit] NULL,
[TypeScrap] [bit] NULL,
[date_stamp_Original] [datetime] NULL,
[Plant] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DashboardCycle_Data_2] ON [HN].[DashboardCycle_Data] ([Plant]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DashboardCycle_Data] ON [HN].[DashboardCycle_Data] ([WeekInYear], [Plant]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DashboardCycle_Data_1] ON [HN].[DashboardCycle_Data] ([WeekInYear], [To_Loc], [Plant]) ON [PRIMARY]
GO
