CREATE TABLE [FT].[AuditSnapShotSerials]
(
[originalSnapshotDT] [datetime] NULL,
[NewSnapShotDT] [datetime] NOT NULL,
[CreatedDT] [datetime] NOT NULL,
[ShippedDT] [datetime] NULL,
[serial] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
