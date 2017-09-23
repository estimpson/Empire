CREATE TABLE [dbo].[ReceiptAuthResults]
(
[Fabweek] [int] NULL,
[FABDate] [datetime] NULL,
[FABGeneratedWeek] [int] NULL,
[FabGeneratedDate] [datetime] NULL,
[FABAuthPONumber] [int] NULL,
[FABAuthPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FABAuthAuthorizedAccum] [numeric] (20, 6) NULL,
[MAxAccum] [numeric] (20, 6) NULL,
[HighestFAB] [numeric] (20, 6) NULL,
[vendorcode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendorname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendorcontact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendorphone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccumReceived] [numeric] (20, 6) NULL,
[UnauthReceiptsQty] [numeric] (20, 6) NULL,
[LastReceivedDate] [datetime] NULL,
[TotalQtyOnPO] [numeric] (20, 6) NULL,
[firsTDueDate] [datetime] NULL,
[lastDueDate] [datetime] NULL,
[Lead_time] [int] NULL,
[FABAuthorizationsReleaseplanID] [int] NULL,
[currentWeek] [int] NULL
) ON [PRIMARY]
GO
