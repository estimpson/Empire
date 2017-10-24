CREATE TABLE [FT].[ReceivingHistory]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[AccumOrdered] [numeric] (20, 6) NOT NULL,
[OrderedReleasePlanID] [int] NULL,
[AuthorizedAccum] [numeric] (20, 6) NOT NULL,
[AuthorizedReleasePlanID] [int] NULL,
[ReceivedAccum] [numeric] (20, 6) NOT NULL,
[LastReceivedDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReceivingHistory] ADD CONSTRAINT [PK__ReceivingHistory__611C5D5B] PRIMARY KEY CLUSTERED  ([PONumber], [Part], [WeekNo]) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReceivingHistory] ADD CONSTRAINT [FK__Receiving__Order__57E7F8DC] FOREIGN KEY ([OrderedReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
ALTER TABLE [FT].[ReceivingHistory] ADD CONSTRAINT [FK__Receiving__Autho__56F3D4A3] FOREIGN KEY ([AuthorizedReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
