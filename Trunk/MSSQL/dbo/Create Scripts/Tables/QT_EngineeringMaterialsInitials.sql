USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_EngineeringMaterialsInitials]    Script Date: 03/04/2013 11:37:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EEIUser].[QT_EngineeringMaterialsInitials](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Initials] [varchar](10) NULL,
	[FirstName] [varchar](25) NULL,
	[LastName] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

