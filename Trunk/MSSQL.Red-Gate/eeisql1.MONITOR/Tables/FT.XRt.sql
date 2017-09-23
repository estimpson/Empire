CREATE TABLE [FT].[XRt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TopPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BOMID] [int] NULL,
[Sequence] [smallint] NULL,
[BOMLevel] [smallint] NOT NULL CONSTRAINT [DF__XRt__BOMLevel__71E2646A] DEFAULT ((0)),
[XQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__XRt__XQty__72D688A3] DEFAULT ((1)),
[XBufferTime] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__XRt__XBufferTime__73CAACDC] DEFAULT ((0)),
[XRunRate] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__XRt__XRunRate__74BED115] DEFAULT ((0)),
[BeginOffset] [int] NOT NULL CONSTRAINT [DF__XRt__BeginOffset__75B2F54E] DEFAULT ((0)),
[EndOffset] [int] NOT NULL CONSTRAINT [DF__XRt__EndOffset__76A71987] DEFAULT ((2147483647)),
[Infinite] [smallint] NOT NULL CONSTRAINT [DF__XRt__Infinite__779B3DC0] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[XRt] ADD CONSTRAINT [PK__XRt__70EE4031] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_1] ON [FT].[XRt] ([BOMLevel], [ChildPart], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_3] ON [FT].[XRt] ([ChildPart], [BOMLevel], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_4] ON [FT].[XRt] ([ChildPart], [TopPart], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_2] ON [FT].[XRt] ([TopPart], [BeginOffset], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_5] ON [FT].[XRt] ([TopPart], [ChildPart], [XQty], [ID]) ON [PRIMARY]
GO
