CREATE TABLE [EEIUser].[acctg_csm_GanttDependencies]
(
[ID] [int] NOT NULL,
[PredecessorID] [int] NOT NULL,
[SuccessorID] [int] NOT NULL,
[Type] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_GanttDependencies] ADD CONSTRAINT [PK_GanttDependencies] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
