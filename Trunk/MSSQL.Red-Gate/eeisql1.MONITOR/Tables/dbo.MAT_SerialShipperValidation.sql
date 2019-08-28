CREATE TABLE [dbo].[MAT_SerialShipperValidation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Serial] [int] NULL,
[Shipper] [int] NULL,
[CreateBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAT_SerialShipperValidation] ADD CONSTRAINT [PK_MAT_SerialShipperValidation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
