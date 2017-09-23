CREATE TABLE [dbo].[WOShift]
(
[WOID] [int] NOT NULL,
[ShiftDate] [datetime] NOT NULL,
[Shift] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_WOShift_Shift] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WOShift] ADD CONSTRAINT [PK_WOShift] PRIMARY KEY CLUSTERED  ([WOID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WOShift] WITH NOCHECK ADD CONSTRAINT [FK_WOShift_WorkOrderHeader] FOREIGN KEY ([WOID]) REFERENCES [dbo].[WOHeaders] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the shift. Null [no shift], 1/A [first shift], 2/B [second shift], 3/C [third shift], etc...', 'SCHEMA', N'dbo', 'TABLE', N'WOShift', 'COLUMN', N'Shift'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time of the beginning of the shift.', 'SCHEMA', N'dbo', 'TABLE', N'WOShift', 'COLUMN', N'ShiftDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID from WorkOrderHeader that identifies a job bundle.', 'SCHEMA', N'dbo', 'TABLE', N'WOShift', 'COLUMN', N'WOID'
GO
