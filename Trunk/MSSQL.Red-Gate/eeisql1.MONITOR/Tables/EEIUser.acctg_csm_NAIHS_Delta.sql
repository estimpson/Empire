CREATE TABLE [EEIUser].[acctg_csm_NAIHS_Delta]
(
[ID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_acctg_csm_NAIHS_Delta_ID] DEFAULT (newid()),
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Manufacturer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Body Style] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New timing] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prior Timing] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mnemonic-Vehicle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Core Nameplate Plant Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Core Nameplate Region Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Notes] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_NAIHS_Delta] ADD CONSTRAINT [PK_acctg_csm_NAIHS_Delta_1] PRIMARY KEY CLUSTERED  ([ID], [Release_ID], [Version], [Mnemonic-Vehicle]) ON [PRIMARY]
GO
