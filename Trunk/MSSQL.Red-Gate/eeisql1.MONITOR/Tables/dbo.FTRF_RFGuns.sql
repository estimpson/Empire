CREATE TABLE [dbo].[FTRF_RFGuns]
(
[ID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScanIndicator] [int] NULL,
[ScreenWidth] [int] NULL,
[ScreenHeight] [int] NULL,
[TimeoutValue] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_RFGuns] ADD CONSTRAINT [PK__FTRF_RFGuns__5006DFF2] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
