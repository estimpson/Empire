CREATE TABLE [dbo].[PODetail_Historical]
(
[po_number] [int] NOT NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[date_due] [datetime] NOT NULL,
[row_id] [numeric] (20, 6) NOT NULL,
[last_recvd_date] [datetime] NULL,
[LastReceivedDT] [datetime] NULL,
[last_recvd_amount] [numeric] (20, 6) NULL,
[LastReceivedAmount] [numeric] (20, 6) NOT NULL,
[balance] [numeric] (20, 6) NULL,
[NewBalance] [numeric] (20, 6) NULL,
[received] [numeric] (20, 6) NULL,
[NewReceived] [numeric] (20, 6) NULL,
[ProcessDT] [datetime] NULL CONSTRAINT [DF__PODetail___Proce__06F6EC30] DEFAULT (getdate())
) ON [PRIMARY]
GO
