CREATE TABLE [dbo].[WODMaterialAllocations]
(
[WODID] [int] NOT NULL,
[Sequence] [tinyint] NULL,
[Suffix] [tinyint] NULL,
[BOMID] [int] NOT NULL,
[Status] [smallint] NOT NULL CONSTRAINT [DF_WODMaterialAllocations_Status] DEFAULT ((0)),
[AllocationDT] [datetime] NOT NULL CONSTRAINT [DF_WODMaterialAllocation_AllocationDT] DEFAULT (getdate()),
[Serial] [int] NOT NULL,
[QtyOriginal] [numeric] (20, 6) NOT NULL,
[QtyBegin] [numeric] (20, 6) NOT NULL,
[QtyIssued] [numeric] (20, 6) NULL,
[QtyEnd] [numeric] (20, 6) NULL,
[QtyEstimatedEnd] [numeric] (20, 6) NULL,
[QtyOverage] [numeric] (20, 6) NULL,
[FIFO] [tinyint] NOT NULL CONSTRAINT [DF_WODMaterialAllocations_FIFO] DEFAULT ((1)),
[QtyPer] [numeric] (20, 6) NULL,
[ChangeReason] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowablePercentOverage] [numeric] (10, 6) NULL CONSTRAINT [DF_WODMaterialAllocations_AllowablePercentOverage] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WODMaterialAllocations] ADD CONSTRAINT [PK__WODMaterialAlloc__33A79CD4] PRIMARY KEY CLUSTERED  ([WODID], [BOMID], [AllocationDT], [Serial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WODMaterialAllocations_1] ON [dbo].[WODMaterialAllocations] ([AllocationDT], [Serial], [WODID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WODMaterialAllocations_2] ON [dbo].[WODMaterialAllocations] ([Serial], [AllocationDT], [WODID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WODMaterialAllocations_3] ON [dbo].[WODMaterialAllocations] ([WODID], [AllocationDT], [Serial]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WODMaterialAllocations] WITH NOCHECK ADD CONSTRAINT [FK_WODMaterialAllocation_WODetail] FOREIGN KEY ([WODID]) REFERENCES [dbo].[WODetails] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies when a material was allocated.  Materials are typically consumed FIFO.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'AllocationDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID from bill_of_material_ec that identifies the parent-child relationship.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'BOMID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity associated to the serial when it is allocated.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyBegin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity associated to the serial when the job is finished.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The estimated remaining quantity associated to the serial when the job is finished.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyEstimatedEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity issued against the serial.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyIssued'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity associated to the first audit trail transaction of the seria.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyOriginal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity consumed beyond the quantity available.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'QtyOverage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The serial number of the material allocated.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'Serial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies whether the material is 0 (in use), 1 (finished).', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID from WODetail that identifies a job.', 'SCHEMA', N'dbo', 'TABLE', N'WODMaterialAllocations', 'COLUMN', N'WODID'
GO
