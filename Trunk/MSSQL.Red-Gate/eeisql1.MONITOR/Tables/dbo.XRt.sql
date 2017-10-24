CREATE TABLE [dbo].[XRt]
(
[ID] [int] NOT NULL,
[TopPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [smallint] NULL,
[BOMLevel] [smallint] NOT NULL,
[XQty] [decimal] (30, 12) NOT NULL,
[XBufferTime] [decimal] (30, 12) NOT NULL,
[XRunRate] [decimal] (30, 12) NOT NULL,
[BeginOffset] [int] NOT NULL,
[EndOffset] [int] NOT NULL,
[Infinite] [smallint] NOT NULL
) ON [PRIMARY]
GO
