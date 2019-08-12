CREATE TABLE [HN].[Picklist_RF_SerialPickedLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Operator] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Serial] [int] NOT NULL,
[LastAction] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdateDT] [datetime] NULL,
[LastOperatorAction] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDT] [datetime] NULL CONSTRAINT [DF__Picklist___Creat__26CE2129] DEFAULT (getdate()),
[ShipperID] [int] NOT NULL,
[Validado] [int] NULL CONSTRAINT [DF_Picklist_RF_SerialPickedLog_Validado] DEFAULT ((0)),
[ValidadoBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidadoDT] [datetime] NULL,
[Comentarios] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Picklist_RF_SerialPickedLog] ADD CONSTRAINT [PK__Picklist__3214EC0724E5D8B7] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Picklist_RF_SerialPickedLog_1] ON [HN].[Picklist_RF_SerialPickedLog] ([Serial], [ShipperID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Validado, 0 = No Validado', 'SCHEMA', N'HN', 'TABLE', N'Picklist_RF_SerialPickedLog', 'COLUMN', N'Validado'
GO
