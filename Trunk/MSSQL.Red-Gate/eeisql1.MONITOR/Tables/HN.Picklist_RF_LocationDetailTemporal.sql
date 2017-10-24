CREATE TABLE [HN].[Picklist_RF_LocationDetailTemporal]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ShipperID] [int] NULL,
[Location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrossRef] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lot] [int] NULL,
[Available] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BestOption] [int] NULL,
[BoxType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDT] [datetime] NULL CONSTRAINT [DF__Picklist___Trans__0D0E4F26] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Picklist_RF_LocationDetailTemporal] ADD CONSTRAINT [PK__Picklist__3214EC270B2606B4] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
