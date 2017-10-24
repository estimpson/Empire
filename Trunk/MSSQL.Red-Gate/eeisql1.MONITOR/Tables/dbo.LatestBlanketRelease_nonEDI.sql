CREATE TABLE [dbo].[LatestBlanketRelease_nonEDI]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VendorPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[Schedtype] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DueDT] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PoDetaildueDate] [datetime] NULL
) ON [PRIMARY]
GO
