CREATE TABLE [dbo].[ReleasePlanPOs]
(
[ReleasePlanID] [int] NOT NULL,
[VendorCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LeadDays] [numeric] (6, 2) NULL,
[LeadDT] [datetime] NOT NULL,
[CurrentAccum] [numeric] (20, 6) NULL,
[LeadAccum] [numeric] (20, 6) NULL,
[FinalAccumReceived] [numeric] (20, 6) NULL,
[LastReceivedDT] [datetime] NULL,
[AccumAdjust] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
