CREATE TABLE [HN].[Picklist_RF_SerialPickedLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Operator] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Serial] [int] NOT NULL,
[LastAction] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdateDT] [datetime] NULL,
[LastOperatorAction] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDT] [datetime] NULL CONSTRAINT [DF__Picklist___Creat__26CE2129] DEFAULT (getdate()),
[ShipperID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Picklist_RF_SerialPickedLog] ADD CONSTRAINT [PK__Picklist__3214EC0724E5D8B7] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
