CREATE TABLE [dbo].[eei_finished_goods_targetCSM]
(
[basepart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[team_no] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customerGroup] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cost] [decimal] (20, 6) NULL,
[min] [decimal] (20, 6) NULL,
[max] [decimal] (20, 6) NULL,
[approved] [decimal] (20, 6) NULL,
[nonapproved] [decimal] (20, 6) NULL,
[std_pack] [decimal] (20, 6) NULL,
[total_inv] [decimal] (20, 6) NULL,
[AvgWeeklyDemand] [decimal] (20, 6) NULL,
[TargetVariance] [decimal] (20, 6) NULL,
[CSMMonthOne] [datetime] NULL,
[CSMMonthTwo] [datetime] NULL,
[CSMWeeklyAvg] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
