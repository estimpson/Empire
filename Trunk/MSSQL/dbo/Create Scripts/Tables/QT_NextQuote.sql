USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_NextQuote]    Script Date: 03/04/2013 11:38:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EEIUser].[QT_NextQuote](
	[QuoteYear] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[NextQuoteNumber] [int] NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[RowCreateDT] [datetime] NULL,
	[RowCreateUser] [sysname] NOT NULL,
	[RowModifiedDT] [datetime] NULL,
	[RowModifiedUser] [sysname] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[QuoteYear] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT (getdate()) FOR [RowCreateDT]
GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT (suser_name()) FOR [RowCreateUser]
GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT (getdate()) FOR [RowModifiedDT]
GO

ALTER TABLE [EEIUser].[QT_NextQuote] ADD  DEFAULT (suser_name()) FOR [RowModifiedUser]
GO

