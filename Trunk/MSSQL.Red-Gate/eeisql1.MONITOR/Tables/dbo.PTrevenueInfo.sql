CREATE TABLE [dbo].[PTrevenueInfo]
(
[BasePart] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionPrice] [money] NULL,
[ProgramManager] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOPdate] [datetime] NULL,
[ID] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
