
 
;fn = '~/idl/project/swarm/SW_OPER_MAGA_LR_1B_20131208T000000_20131208T235959_0503_MDR_MAG_LR.cdf'
;fn = '/Volumes/spel_data/10Spacecrafts/Cluster/C3_PP_FGM/C3_PP_FGM__20080210_212900_20080210_222900_V091216.cdf'
;fn = '~/data/cluster/C3_PP_FGM/C3_PP_FGM__20080106_045700_20080106_055700_V091216.cdf'
;fn = '~/idl/project/swarm/SW_EXPT_EFIA_TCT16_20150117T000000_20150117T235959_0302.cdf'
;fn = '/Volumes/spel_data/10Spacecrafts/Cluster/C3_CP_STA_PSD/C3_CP_STA_PSD__20040310_120000_20040310_130000_V150122.cdf'
fn = '~/idl/project/swarm/SW_OPER_MAGB_HR_1B_20220103T000000_20220103T235959_0602_MDR_MAG_HR.cdf'

;fn = '~/idl/project/swarm/SW_EXPT_EFIB_TCT16_20220103T011751_20220103T135007_0302.cdf'
c = obj_new('cdf')
c.filename=fn

c->varinfo



end   
