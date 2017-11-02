CREATE TABLE [EEIUser].[QT_QuoteLog_orig]
(
[Quote #] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Receipt Date] [datetime] NULL,
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Requested Due Date] [datetime] NULL,
[EEI Promised Due Date] [datetime] NULL,
[Customer P/N] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEI P/N] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requote] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EAU] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Application] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[App# Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Function] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[End User] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model Year] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EOP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Eng] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issues / Problems / Notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer RFQ #] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTA %] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTA YRS] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering & Materials Initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering & Materials Date] [datetime] NULL,
[Quote Review Initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Review Date] [datetime] NULL,
[Quote Pricing Initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Pricing Date] [datetime] NULL,
[Customer Quote Initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Quote Date] [datetime] NULL,
[Quoted Price] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total Quoted Sales] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quote Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New Business Awarded] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO