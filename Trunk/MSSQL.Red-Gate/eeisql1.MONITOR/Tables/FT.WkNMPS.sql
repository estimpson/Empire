CREATE TABLE [FT].[WkNMPS]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[FrozenPOBalance] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__WkNMPS__FrozenPO__66F53241] DEFAULT ((0)),
[POBalance] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__WkNMPS__POBalanc__67E95671] DEFAULT ((0)),
[PriorPOAccum] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__WkNMPS__PriorPOA__68DD7AB1] DEFAULT ((0)),
[PriorDemandAccum] [numeric] (30, 12) NOT NULL,
[PostDemandAccum] [numeric] (30, 12) NOT NULL,
[DeliveryDW] [int] NOT NULL,
[FrozenWeeks] [int] NOT NULL,
[RoundingMethod] [int] NOT NULL,
[StandardPack] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[WkNMPS] ADD CONSTRAINT [PK__WkNMPS__66010E01] PRIMARY KEY CLUSTERED  ([Part], [WeekNo]) ON [PRIMARY]
GO
