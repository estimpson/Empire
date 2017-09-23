CREATE TABLE [dbo].[WOHeaders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CreateDT] [datetime] NULL CONSTRAINT [DF_WOHeaders_CreateDT] DEFAULT (getdate()),
[Status] [smallint] NOT NULL CONSTRAINT [DF_WorkOrderHeader_Status] DEFAULT ((0)),
[Machine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tool] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [smallint] NOT NULL CONSTRAINT [DF_WorkOrderHeader_Type] DEFAULT ((0)),
[Sequence] [int] NULL,
[SetupHours] [numeric] (20, 6) NOT NULL CONSTRAINT [DF_WorkOrderHeader_SetupHours] DEFAULT ((0)),
[StartDT] [datetime] NULL,
[EndDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WOHeaders] ADD CONSTRAINT [PK_WorkOrderHeader] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WOHeaders_Machine] ON [dbo].[WOHeaders] ([Machine], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Machine_Status_ID] ON [dbo].[WOHeaders] ([Machine], [Status], [Type], [ID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[WOHeaders] TO [APPUser]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The scheduled end date/time for a job bundle.', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'EndDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID that identifies a group of jobs that will run together, usually because they have the same tool (job bundle).', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The machine where the job bundle was/is/will run.', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'Machine'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the order in which this job bundle runs on a machine [tie goes to lowest ID].', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'Sequence'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of setup time planned for this job bundle.', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'SetupHours'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The scheduled start date/time for a job bundle.', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'StartDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies whether job bundle is 0 (open), 1 (closed).', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A tool or tool set required to run the job bundle [part machine tool].', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'Tool'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies whether job bundle is 0 (firm), 1 (planned).', 'SCHEMA', N'dbo', 'TABLE', N'WOHeaders', 'COLUMN', N'Type'
GO
