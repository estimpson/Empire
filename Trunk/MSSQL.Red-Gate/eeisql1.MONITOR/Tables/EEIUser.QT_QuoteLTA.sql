CREATE TABLE [EEIUser].[QT_QuoteLTA]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EffectiveDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Percentage] [decimal] (20, 0) NULL,
[LTAYear] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteLTA] ADD CONSTRAINT [PK_QT_QuoteLTA] PRIMARY KEY CLUSTERED  ([QuoteNumber], [EffectiveDate]) ON [PRIMARY]
GO
