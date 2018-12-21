CREATE TABLE [dbo].[PilotInv20180825]
(
[Part] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Lot] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Qty] [int] NOT NULL,
[CrossRef] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
