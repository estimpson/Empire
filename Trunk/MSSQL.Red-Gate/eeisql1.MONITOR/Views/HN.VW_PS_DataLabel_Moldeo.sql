SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE view [HN].[VW_PS_DataLabel_Moldeo]
as
select      WOID = WODetails.id, WODID = convert(varchar,WODetails.id), part, machine, ShiftDate, Shift=isnull(Shift,''), FirstPiecE=ISNULL(FirstPiece,''), LastPiece=ISNULL(LastPiece,''),
Familia = (Select top 1 Familia='TRW'
			from	ft.xrt
			where	ChildPart=part
				and	toppart like 'trw%'),                       

                        Legend = coalesce( (select 'Botar'
											from	Part_Characteristics
											where	part = WODetails.Part
													--and isnull(Drop_Runner,'N' ) = 'Y'
													),
                        
										(
                                          select      Max('RUNNER')
                                          from  ft.xrt xrt
                                                      join part on part.part = xrt.ChildPart
                                          where toppart     = woDetails.Part
                                                      and commodity = 'REGRIND'
                                                      and part.type = 'W'
                                                      and xrt.childpart not in (select Part from hn.Meltflow_parts )
                                                      and xrt.bomid not in (	select	bomid 
																				from	ft.xrt 
																				where	bomid is not null and 
																						toppart in (	select part 
																										from HN.Meltflow_parts))
                                                      
                                                      ),
                                          (select     Max('RUNNER')
                                          from  hn.BF_Rename_Regrind
                                          where Toppart = WODetails.Part
												and SourcePart in (   select      childpart
                                                                              from	ft.xrt xrt
                                                                                    join part on part.part = xrt.ChildPart
                                                                              where toppart = woDetails.Part
                                                                                    and xrt.childpart not in (select Part from hn.Meltflow_parts )
                                                                                    and xrt.BOMID not in (	select	bomid 
																											from	ft.xrt 
																											where	bomid is not null and 
																													toppart in (	select part 
																														from HN.Meltflow_parts))
                                                                                    and commodity = 'COMPOUND' ))
                                                                                          ,'BOTAR')
            from  WOHeaders
                        join WODetails on WOHeaders.id = WODetails.woid
                        join WOShift on WODetails.WOID = WOShift.WOID
                        left join WOAditionalInfo on WODetails.ID = WOAditionalInfo.NewWODID









GO
GRANT SELECT ON  [HN].[VW_PS_DataLabel_Moldeo] TO [APPUser]
GO
