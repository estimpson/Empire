CREATE TABLE [dbo].[BillOfMaterial_fxDelete]
(
[ParentPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
