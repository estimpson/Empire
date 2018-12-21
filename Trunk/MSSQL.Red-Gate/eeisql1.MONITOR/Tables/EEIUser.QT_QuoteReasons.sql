CREATE TABLE [EEIUser].[QT_QuoteReasons]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[QuoteReason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BasePartReplacementFlag] [bit] NOT NULL CONSTRAINT [DF_QT_QuoteReasons_BasePartReplacementFlag] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteReasons] ADD CONSTRAINT [PK_QT_QuoteReasons] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
