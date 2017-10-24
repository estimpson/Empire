CREATE TABLE [EEIUser].[QT_QuoteLog2012_orig]
(
[Quote #] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Receipt Date] [datetime2] NULL,
[Customer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Requested Due Date] [datetime2] NULL,
[EEI Promised Due Date] [datetime2] NULL,
[Customer P/N] [float] NULL,
[EEI P/N] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requote] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer EAU] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[App# Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Function] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[End User] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name Plate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model Year] [int] NULL,
[SOP] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EOP] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PM] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Eng] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issues / Problems / Notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering & Materials Initials] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering & Materials Date] [datetime2] NULL,
[Quote Review Initials] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Review Date] [datetime2] NULL,
[Quote Pricing Initials] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Pricing Date] [datetime2] NULL,
[Customer Quote Initials] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Quote Date] [datetime2] NULL,
[Quoted Price] [money] NULL,
[Total Quoted Sales] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pivot Table Filter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
