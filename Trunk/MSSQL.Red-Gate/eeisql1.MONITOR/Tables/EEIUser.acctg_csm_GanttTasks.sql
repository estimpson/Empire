CREATE TABLE [EEIUser].[acctg_csm_GanttTasks]
(
[ID] [int] NOT NULL,
[ParentID] [int] NULL,
[OrderID] [int] NOT NULL,
[Vehicle] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Base_part] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Empire_market_subsegment] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start] [datetime] NOT NULL,
[End] [datetime] NOT NULL,
[PercentComplete] [decimal] (5, 2) NOT NULL,
[Expanded] [bit] NULL,
[Summary] [bit] NOT NULL CONSTRAINT [DF_GanttTasks_Summary] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_GanttTasks] ADD CONSTRAINT [PK_GanttTasks] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
