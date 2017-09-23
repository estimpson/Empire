CREATE TABLE [dbo].[WODetails]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[WOID] [int] NOT NULL,
[CreateDT] [datetime] NULL CONSTRAINT [DF_WODetails_CreateDT] DEFAULT (getdate()),
[TopPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NOT NULL CONSTRAINT [DF_WODetail_Status] DEFAULT ((0)),
[Sequence] [int] NULL,
[DueDT] [datetime] NULL,
[QtyRequired] [numeric] (20, 6) NOT NULL,
[QtyLabelled] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WODetail_QtyLabelled] DEFAULT ((0)),
[QtyCompleted] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WODetail_QtyCompleted] DEFAULT ((0)),
[QtyDefect] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WODetail_QtyDefect] DEFAULT ((0)),
[QtyRework] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WODetail_QtyRework] DEFAULT ((0)),
[SetupHours] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WODetail_SetupHours] DEFAULT ((0)),
[StartDT] [datetime] NULL,
[EndDT] [datetime] NULL,
[SourceType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WODetails] ADD CONSTRAINT [PK_WODetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX1_WODetails_PartWOIDQtys] ON [dbo].[WODetails] ([Part], [WOID], [QtyRequired], [QtyCompleted]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WODetails] WITH NOCHECK ADD CONSTRAINT [FK_WODetail_WorkOrderHeader] FOREIGN KEY ([WOID]) REFERENCES [dbo].[WOHeaders] ([ID])
GO
GRANT SELECT ON  [dbo].[WODetails] TO [APPUser]
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the job is required to be finished.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'DueDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The scheduled end date/time for a job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'EndDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID that identifies a job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The part produced by this job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'Part'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity that has been completed.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'QtyCompleted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity that has been produced defective.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'QtyDefect'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity that has been pre-labelled.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'QtyLabelled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity required to complete the job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'QtyRequired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity that has been reworked.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'QtyRework'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the order in which this job runs as part of a job bundle [tie goes to lowest ID].', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'Sequence'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of setup time planned for this job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'SetupHours'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The scheduled start date/time for a job.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'StartDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies whether job  is 0 (open), 1 (closed).', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID from WorkOrderHeader that identifies a job bundle.', 'SCHEMA', N'dbo', 'TABLE', N'WODetails', 'COLUMN', N'WOID'
GO
