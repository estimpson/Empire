CREATE TABLE [dbo].[PhysicalInventoryHeaders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDT] [datetime] NOT NULL,
[EndDT] [datetime] NOT NULL,
[BoxesStarting] [int] NOT NULL,
[BoxesFoundInPos] [int] NULL,
[BoxesFoundInRow] [int] NULL,
[BoxesMissing] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PhysicalInventoryHeaders] ADD CONSTRAINT [PK__PhysicalInventor__22A0D34C] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
