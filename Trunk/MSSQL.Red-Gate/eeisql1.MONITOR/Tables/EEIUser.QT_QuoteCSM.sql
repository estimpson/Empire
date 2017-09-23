CREATE TABLE [EEIUser].[QT_QuoteCSM]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CSM_Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteCSM] ADD CONSTRAINT [PK__QT_Quote__8A47966B707F0010] PRIMARY KEY CLUSTERED  ([QuoteNumber], [CSM_Mnemonic]) ON [PRIMARY]
GO
