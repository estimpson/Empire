CREATE TABLE [FT].[EmailTransferredSerialsList]
(
[Serial] [int] NULL,
[PartNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [numeric] (20, 6) NULL,
[Operator] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scheduler] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
