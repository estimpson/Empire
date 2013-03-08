USE [MONITOR]
GO

/****** Object:  Table [EEIUser].[QT_Functions]    Script Date: 03/04/2013 11:37:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EEIUser].[QT_Functions](
	[FunctionCode] [varchar](50) NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[Description] [varchar](255) NULL,
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
	[FunctionCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT (getdate()) FOR [RowCreateDT]
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT (suser_name()) FOR [RowCreateUser]
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT (getdate()) FOR [RowModifiedDT]
GO

ALTER TABLE [EEIUser].[QT_Functions] ADD  DEFAULT (suser_name()) FOR [RowModifiedUser]
GO

