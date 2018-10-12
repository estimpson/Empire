CREATE TABLE [dbo].[DPCB]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TransactionDT] [datetime] NOT NULL,
[Machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefectCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyScrapped] [numeric] (20, 6) NULL,
[Operator] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Shift] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WODID] [int] NULL,
[DefectSerial] [int] NULL,
[Comments] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditTrailID] [int] NULL,
[AreaToCharge] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyOverage] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
