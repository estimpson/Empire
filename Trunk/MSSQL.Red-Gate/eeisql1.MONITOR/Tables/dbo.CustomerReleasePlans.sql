CREATE TABLE [dbo].[CustomerReleasePlans]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GeneratedDT] [datetime] NOT NULL CONSTRAINT [DF__CustomerR__Gener__561FABFB] DEFAULT (getdate()),
[GeneratedWeekNo] [int] NOT NULL,
[GeneratedWeekDay] [smallint] NOT NULL CONSTRAINT [DF__CustomerR__Gener__5713D034] DEFAULT (datepart(weekday,getdate())),
[BaseDT] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerReleasePlans] ADD CONSTRAINT [PK__CustomerReleaseP__552B87C2] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
