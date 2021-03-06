CREATE TABLE [EEIUser].[acctg_csm_NAIHS_header]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Core Nameplate Region Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Core Nameplate Plant Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic-Vehicle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic-Vehicle/Plant] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mnemonic-Platform] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Market] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant State/Province] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Design Parent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturing Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales Parent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Brand] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform Design Owner] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Architecture] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[Lifecycle (Time)] [int] NULL,
[Vehicle] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assembly Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Strategic Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Nameplate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Center] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Center] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GVW Rating] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GVW Class] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Car/Truck] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Production Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Production Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regional Sales Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Production Price Class] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Sub-Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Price Class] [int] NULL,
[Short Term Risk Rating] [int] NULL,
[Long Term Risk Rating] [int] NULL,
[RolledForward] [int] NULL,
[RowCreatedUser] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreatedDT] [datetime2] NULL CONSTRAINT [DF__acctg_csm__RowCr__3207C9EA] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_NAIHS_header] ADD CONSTRAINT [PK_acctg_csm_NAIHS_header] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
