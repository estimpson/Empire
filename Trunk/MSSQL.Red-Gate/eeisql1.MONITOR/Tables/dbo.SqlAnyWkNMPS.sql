CREATE TABLE [dbo].[SqlAnyWkNMPS]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[FrozenPOBalance] [decimal] (30, 12) NOT NULL,
[POBalance] [decimal] (30, 12) NOT NULL,
[PriorPOAccum] [decimal] (30, 12) NOT NULL,
[PriorDemandAccum] [decimal] (30, 12) NOT NULL,
[PostDemandAccum] [decimal] (30, 12) NOT NULL,
[DeliveryDW] [int] NOT NULL,
[FrozenWeeks] [int] NOT NULL,
[RoundingMethod] [int] NOT NULL,
[StandardPack] [int] NOT NULL
) ON [PRIMARY]
GO
