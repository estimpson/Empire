CREATE TABLE [dbo].[TemporalDataDashboard]
(
[IdRow] [int] NOT NULL,
[Part_Number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[Due_Date] [date] NULL,
[Customer_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cum_Order] [int] NULL,
[Approve] [int] NULL,
[OnHold] [int] NULL,
[Show_After_Part] [int] NULL,
[Cum_HoldNeed] [int] NULL,
[Sort_Needed] [int] NULL,
[Show_On_Dashboard] [int] NULL,
[Week] [int] NULL,
[Year] [int] NULL,
[Destination] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Acum_SecondsPieceRate] [decimal] (18, 2) NULL,
[Hours_required] [decimal] (18, 2) NULL,
[Resources] [decimal] (18, 2) NULL,
[CreateBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDT] [datetime] NULL
) ON [PRIMARY]
GO
