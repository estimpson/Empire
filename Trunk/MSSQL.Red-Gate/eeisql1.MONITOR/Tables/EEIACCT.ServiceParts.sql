CREATE TABLE [EEIACCT].[ServiceParts]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartNumber] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndOfServiceYear] [int] NULL,
[Scheduler] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active2011Demand] [int] NULL,
[Active2012Demand] [int] NULL,
[Shipped2011Demand] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[ServiceParts] ADD CONSTRAINT [PK__ServiceP__A91CCA1074CCEB69] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
