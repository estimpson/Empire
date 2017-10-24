CREATE TABLE [dbo].[Ft2BlanketOrderDistributeReleases_Edit]
(
[SPID] [int] NULL,
[Status] [int] NOT NULL,
[Type] [int] NOT NULL,
[ActiveOrderNo] [int] NULL,
[OrderNo] [int] NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseDT] [datetime] NULL,
[ReleaseType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRelease] [numeric] (20, 6) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL,
[RowCreateUser] [sys].[sysname] NOT NULL,
[RowModifiedDT] [datetime] NULL,
[RowModifiedUser] [sys].[sysname] NOT NULL
) ON [PRIMARY]
GO
