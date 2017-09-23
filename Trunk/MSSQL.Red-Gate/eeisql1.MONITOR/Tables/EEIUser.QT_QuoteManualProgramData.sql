CREATE TABLE [EEIUser].[QT_QuoteManualProgramData]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Manufacturer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteManualProgramData] ADD CONSTRAINT [PK__QT_Quote__8A47966B07033E0C] PRIMARY KEY CLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
