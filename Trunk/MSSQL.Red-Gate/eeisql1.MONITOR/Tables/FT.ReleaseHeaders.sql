CREATE TABLE [FT].[ReleaseHeaders]
(
[GUID] [uniqueidentifier] NULL ROWGUIDCOL CONSTRAINT [DF__ReleaseHea__GUID__6A7BAA63] DEFAULT (newid()),
[ID] [int] NOT NULL IDENTITY(1, 1),
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Owner] [sys].[sysname] NOT NULL CONSTRAINT [DF__ReleaseHe__Owner__6B6FCE9C] DEFAULT (suser_sname()),
[CreateDT] [datetime] NOT NULL CONSTRAINT [DF__ReleaseHe__Creat__6C63F2D5] DEFAULT (getdate()),
[LastUpdateDT] [datetime] NOT NULL CONSTRAINT [DF__ReleaseHe__LastU__6D58170E] DEFAULT (getdate()),
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccumulativeOffset] [numeric] (20, 6) NOT NULL CONSTRAINT [DF__ReleaseHe__Accum__6E4C3B47] DEFAULT ((0)),
[OrderAccum] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReleaseHeaders] ADD CONSTRAINT [PK__ReleaseHeaders__689361F1] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReleaseHeaders] ADD CONSTRAINT [UQ__ReleaseHeaders__6987862A] UNIQUE NONCLUSTERED  ([GUID]) ON [PRIMARY]
GO
