CREATE TABLE [FT].[NetMPS]
(
[ID] [int] NOT NULL,
[OrderNo] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Order__30555B28] DEFAULT ((-1)),
[LineID] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredDT] [datetime] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Requi__31497F61] DEFAULT (getdate()),
[Balance] [numeric] (30, 12) NOT NULL,
[OnHandQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__OnHan__323DA39A] DEFAULT ((0)),
[WIPQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__WIPQt__3331C7D3] DEFAULT ((0)),
[LowLevel] [int] NOT NULL,
[Sequence] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[NetMPS] ADD CONSTRAINT [PK__NetMPS_N__3214EC272E6D12B6] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NetMPS_1] ON [FT].[NetMPS] ([LowLevel], [Part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NetMPS_2] ON [FT].[NetMPS] ([Part], [RequiredDT], [Balance]) ON [PRIMARY]
GO
