CREATE TABLE [HN].[Picklist_RF_SerialPickedTemporal]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ShipperID] [int] NULL,
[CrossRef] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[LastDate] [datetime] NULL,
[standard_pack] [int] NULL,
[TransDT] [datetime] NULL CONSTRAINT [DF__Picklist___Trans__11D30443] DEFAULT (getdate()),
[Serial] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Picklist_RF_SerialPickedTemporal] ADD CONSTRAINT [PK__Picklist__3214EC270FEABBD1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
