CREATE TABLE [dbo].[POReleaseImport_Stanley]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[VendorPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartDescription] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [numeric] (20, 6) NULL,
[DueDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POReleaseImport_Stanley] ADD CONSTRAINT [PK__PoReleas__3214EC2724386E1B] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
