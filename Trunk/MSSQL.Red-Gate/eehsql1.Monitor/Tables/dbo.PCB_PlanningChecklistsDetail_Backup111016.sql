CREATE TABLE [dbo].[PCB_PlanningChecklistsDetail_Backup111016]
(
[IDPCBPlanningChecklistsDetail] [int] NOT NULL IDENTITY(1, 1),
[IDPCBPlanningChecklists] [int] NOT NULL,
[ValueType] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChecklistApproved] [bit] NULL,
[Answer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Applies] [bit] NULL,
[SubProcess] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainProcessApproved] [bit] NULL
) ON [PRIMARY]
GO
