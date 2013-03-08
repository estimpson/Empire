USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_QuoteCSM]    Script Date: 03/04/2013 11:39:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EEIUser].[QT_QuoteCSM](
	[QuoteNumber] [varchar](50) NOT NULL,
	[CSM_Mnemonic] [varchar](30) NOT NULL,
	[Version] [varchar](30) NULL,
	[Release_ID] [char](7) NULL,
	[Manufacturer] [varchar](50) NULL,
	[Platform] [varchar](255) NULL,
	[Program] [varchar](50) NULL,
	[Nameplate] [varchar](50) NULL,
 CONSTRAINT [PK__QT_Quote__8A47966B707F0010] PRIMARY KEY CLUSTERED 
(
	[QuoteNumber] ASC,
	[CSM_Mnemonic] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

