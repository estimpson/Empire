USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_QuotePrints]    Script Date: 03/04/2013 11:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EEIUser].[QT_QuotePrints](
	[QuoteNumber] [varchar](50) NOT NULL,
	[PrintFilePath] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[QuoteNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

