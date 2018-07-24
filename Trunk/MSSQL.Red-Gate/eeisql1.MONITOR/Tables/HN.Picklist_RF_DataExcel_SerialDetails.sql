CREATE TABLE [HN].[Picklist_RF_DataExcel_SerialDetails]
(
[Operator] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperID] [int] NULL,
[Serial] [int] NULL,
[CrossRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentSerial] [int] NULL,
[Lot] [int] NULL,
[ObjectBirthday] [datetime] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Picklist_RF_DataExcel_SerialDetails] ADD CONSTRAINT [PK_Picklist_RF_DataExcel_SerialDetails] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Picklist_RF_DataExcel_SerialDetails] ON [HN].[Picklist_RF_DataExcel_SerialDetails] ([Operator], [ShipperID]) ON [PRIMARY]
GO
