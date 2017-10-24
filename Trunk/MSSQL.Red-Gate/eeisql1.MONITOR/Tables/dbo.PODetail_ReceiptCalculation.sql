CREATE TABLE [dbo].[PODetail_ReceiptCalculation]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DueDT] [datetime] NOT NULL,
[RowId] [numeric] (20, 6) NOT NULL,
[NewBalance] [numeric] (20, 6) NULL,
[NewReceived] [numeric] (20, 6) NULL,
[LastReceivedAmount] [numeric] (20, 6) NOT NULL,
[LastReceivedDT] [datetime] NULL,
[ProcessDT] [datetime] NULL CONSTRAINT [DF__PODetail___Proce__050EA3BE] DEFAULT (getdate())
) ON [PRIMARY]
GO
