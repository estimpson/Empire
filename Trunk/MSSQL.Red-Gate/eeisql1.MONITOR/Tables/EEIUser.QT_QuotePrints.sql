CREATE TABLE [EEIUser].[QT_QuotePrints]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PrintFilePath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuotePrints] ADD CONSTRAINT [PK__QT_Quote__8A47966B10187251] PRIMARY KEY CLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
