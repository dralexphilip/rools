
insert into clone_lead
select *, 'RULE_24' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('BCBSMROC', 'BCBSMRX1', 'MIBCNRX', 'BCNRXPD')
--Or (subgroup_number = 'BCBSMAN' and coalesce(member_id,'p') <> coalesce(policy_ssn,'s'))) 
;


-- 'Rule 24 - Clone Express Scripts BCBS MI'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS MI',
member_id = 'XYL' || member_id,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_24';



insert into clone_lead
select *, 'RULE_27' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number in ('EXC11', 'EXC14', 'EXC15', 'EXLHPRX', 'EXLHXRX')
or group_name = 'EXCELLUS BLUECROSS BLUESH')
and coalesce(group_name,'') not like 'U ADMIN%' 
and coalesce(group_name,'') not like 'U INDIVIDUAL%'
and coalesce(group_name,'') not like 'U SMALL%'
and coalesce(group_name,'') not like 'U ESSENTIAL%'
and coalesce(group_name,'') not like 'U EXPERIENCE%'
and coalesce(group_name,'') not like '%U HARP%'
and coalesce(group_name,'') not like 'U MINIMUM%'
and coalesce(group_name,'') not like '%UNIVERA%'
and coalesce(group_name,'') not like 'UNIV S CHOICE%'
;

-- 'Rule 27 - Clone Express Scripts Excellus BCBS'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'EXCELLUS BCBS',
--member_id = 'ASB' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_27'
;



insert into clone_lead
select *, 'RULE_29' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
--and (subgroup_number in ('AAAECRX', 'DCSGRX9', 'GTEAGLE', 'HMRK001', 'KMTPHRM', 'NCCRX4U', 'SELMEDRX', 'SPBLUE1', 'SPBLUE3', 'UBCCFRX', 'YCBA') 
--or subgroup_number like '% %')
--and (group_name in ('00177509', '00177511', 'FPH', 'GIANT EAGLE', 'HBG CENTRAL PA', 'HCA WESTERN PA', 'HCRX FPH', 'HCRX PA HHIC CENTRAL', 'HCRX PA HHIC WESTERN', 'HCRX PA KEYSTONE', 'NEPA', 'FREEDOM BLUE') 
--or group_name like '%HIGHMARK%')
and coalesce(group_name,'') not in ('HCRX DE', 'HCRX WV', 'HIGHMARK BCBS WV', 'HIGHMARK CDHP', 'HIGHMARK PLANS')
and coalesce(group_number,'') not in ('LXS000000362917', 'HRK019969650010', 'HRK097356000010', 'HRK102068520010', 'HRK097356010010')
;

-- 'Rule 29 - Clone Express Scripts Highmark BCBS'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
carrier_name = 'HIGHMARK BCBS',
--member_id = case when member_id Like '%001' then 'SLF' || member_id
--when Right(member_id,1) in ('A','B') then member_id 
--else null end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_29'
;


insert into clone_lead
select *, 'RULE_44' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like '%BLUE CROSS OF ARIZONA%';


-- 'Rule 44 - Clone Catamaran BCBS AZ'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS AZ',
--member_id = 'ABD' || left(member_id,9),
group_number = NULL,
group_name = upper(group_desc),
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_44';


insert into clone_lead
select *, 'RULE_51' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'IBC%'
and coalesce(group_name,'') <> 'BLUE CHIP';  


-- 'Rule 51 - Clone Catamaran Independence Blue Cross'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INDEPENDENCE BLUE CROSS',
--member_id = 'QCI' || left(member_id,12),
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_51';


insert into clone_lead
select *, 'RULE_54' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'OPTIMA HEALTH%';


-- 'Rule 54 - Clone Catamaran Optima Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'OPTIMA HEALTH (SENTARA)',
--member_id = case when left(member_id,1) = '9' then NULL else member_id end,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_54';


insert into clone_lead
select *, 'RULE_69' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'CBC -%' or
group_name like 'CBC EXCHANGE%' or
group_name like 'CBC MAPD%' or
group_name like 'CBC OFF%');


-- 'Rule 69 - Clone CVS Caremark Capital Blue Cross'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAPITAL BLUE CROSS',
--member_id = case when left(member_id,1) = '8' then 'YWW' || member_id else NULL end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_69';


insert into clone_lead
select *, 'RULE_72' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and member_id like 'CDS%';


-- 'Rule 72 - Clone CVS Caremark CDS'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CDS GROUP HEALTH',
member_id = policy_ssn,
group_number = left(member_id,9),
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_72';


insert into clone_lead
select *, 'RULE_81' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'HMSA %';


-- 'Rule 81 - Clone CVS Caremark Hawaii Medical Service Assoc'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HAWAII MEDICAL SERVICE ASSOC (BCBS)',
--member_id = 'XLA' || left(member_id,13),  
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_81';


insert into clone_lead
select *,'RULE_93' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'NATL ASSC%';


-- 'Rule 93 - Clone CVS Caremark Nat'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
member_id = NULL,
carrier_name = 'NATIONAL ASSOCIATION OF LETTER CARRIERS',
group_number = NULL,
group_name = 'NATIONAL ASSOCIATION OF LETTER CARRIERS HBP',
--member_ssn = case when Right(rtrim(member_id),1) <> 'A' then Null else member_ssn end,
--policy_ssn = case when Right(rtrim(member_id),1) = 'A' then left(member_id,9)
--else NULL end,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_93';


-- 'Rule 101 - Clone CVS Caremark Tufts Health Plan'

insert into clone_lead
select *, 'RULE_101' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'THP MA%' or
group_name like 'TUFTS 0%' or
group_name like 'TUFTS A%' or
group_name like 'TUFTS C%' or
group_name like 'TUFTS F%' or
group_name like 'TUFTS H2%' or
group_name like 'TUFTS HEALTH%' or
group_name like 'TUFTS HLTH%' or
group_name like 'TUFTS HP H%' or
group_name like 'TUFTS HP M%' or
group_name like 'TUFTS HP-T%' or
group_name like 'TUFTS MEDICAL%' or
group_name like 'TUFTS SE%' or
group_name like 'TUFTS T%' or
group_name like 'TUFTS-%' or
group_name like 'TUFTS/%'or
group_name in ('NETWORK HEALTH QHP','NHPMA COMMERCIAL')) 


;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'TUFTS HEALTH PLAN',
--member_id = case when length(member_id)=9 then member_id || '01' else left(member_id,11) end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_101'

;


-- 'Rule 107 - Clone CVS Caremark Wellmark BCBS'

insert into clone_lead
select *, 'RULE_107' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'WELLMARK%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WELLMARK BCBS',
--member_id = 'WMA' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_107'

;

-- 'Rule 123 - Clone CVS Caremark Carefirst BCBS' -- Added 8/10/2018


insert into clone_lead
select * , 'RULE_123' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'CF-(FACETS)%'
or group_name like 'CF-(NASCO)%'
or group_name like 'CF-NASCO%'
or group_name like 'CF AACPS WRAP%'
or group_name like 'CF FACETS%'
or group_name like 'FAC%'
or group_name like 'EXCHNG DC HMO & NONHMO%'
or group_name like 'EXCHANGE  MD NON HMO%'
or group_name like 'HEALTH EXCHANGE MD HMO%'
or group_name like 'HEALTH EXCHANGE VA%'
or group_name like 'NAS GRP%'
or group_name like 'NASCO GROUP RISK%'
or group_name like 'OFF EXCH%'
or (group_name like 'CF NASCO ASO%' and group_name <> 'CF NASCO ASO F2 T16 NR')) 

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAREFIRST BCBS',
--member_id = 'CAA' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_123'

;

-- 'Rule 126 - Clone Express Scripts BCBS VT'

insert into clone_lead
select *, 'RULE_126' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('L4FA', 'VT7A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS VT',
--member_id = 'ZIA' || left(policy_ssn,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_126'

;
-- 'Rule 127 - Clone Express Scripts Guidestone'

insert into clone_lead
select *, 'RULE_127' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ABSBC01'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GUIDESTONE',
--member_id = 'CQM' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_127'

;

-- 'Rule 141 - Clone CVS Americas Choice'

insert into clone_lead
select *,'RULE_141' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'AMERICA''S CHOICE HEALTHPL'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AMERICA''S CHOICE HEALTHPLANS',
--member_id = case when member_id like 'S%' then Substring(member_id,2,(length(member_id)-3)) else left(member_id,(length(member_id)-2)) end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_141'

;

-- 'Rule 200 - Clone Delta Dental Insurance Company Kaiser Foundation Health Plan'

insert into clone_lead
select *, 'RULE_200' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'KPIC-%'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
--member_id = case
--when member_id Like '000%' then Right(member_id,7)
--when member_id Like '00%' and member_id not like '000%' then Right(member_id,8)
--else NULL end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when member_id Like '000%' then '{MM}'
when member_id Like '00%' and member_id not like '000%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_200'

;

-- 'Rule 202 - Clone Catamaran Kaiser Foundation Health Plan of the Northwest'

insert into clone_lead
select *, 'RULE_202' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'GH COMMERCIAL'  

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
group_number = left(subgroup_number ,7),
group_name = upper(group_desc),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_202'

;

-- 'Rule 217 - Clone Catamaran Assured Benefit Administrators'

insert into clone_lead
select *, 'RULE_217' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTASSURE'

;
update clone_lead
set
carrier_name = 'ASSURED BENEFIT ADMINISTRATORS',
group_number = Right(subgroup_number,4), 
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_217'

;

-- 'Rule 220 - Clone CVS_Caremark BCBS SC'

insert into clone_lead
select * , 'RULE_220' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'BLUECHOICE%'

;
update clone_lead
set
carrier_name = 'BCBS SC',
--member_id = ('ZCL' || left(policy_id,9)),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_220'

;

-- 'Rule 235 - Clone CVS_Caremark HealthSmart'

insert into clone_lead
select *, 'RULE_235' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name IN ('HEALTHSMART', 'PITTMAN & ASSOCIATES', 'BMI HEALTH PLANS')
or group_name like 'MUTUAL ASSURANCE%')

;
update clone_lead
set
carrier_name = 'HEALTHSMART',
--member_id = case
--when left(member_id,1) = 'K' then Left(member_id,11)
--else NULL end,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_235'

;
-- 'Rule 236 - Clone Catamaran BCBS IL (HCSC)'

insert into clone_lead
select *, 'RULE_236' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTUNITE'
and subgroup_number in ('UHH00106','UHH00114','UHH00115','UHH00116','UHH00117','UHH05123','UHH00173','UHH04173','UHH01173','UHH00174','UHH00175','UHH00176','UHH01176','UHH02176','UHH00178','UHH00185','UHH01185','UHH01376','UHH00376','UHH02376','UHH03376','UHH00414') --Added 2/14/2019 DM3.6_Updates

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
--member_id = case
--when policy_id_alt like 'HE%' then 'HPU00' || Right(policy_id_alt,length(policy_id_alt)-2)  
--else policy_id_alt end,
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_236'

;

-- 'Rule 294 - Clone Catamaran Gilsbar'

insert into clone_lead
select *, 'RULE_294' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'GILSBAR%'

;
update clone_lead
set
carrier_name = 'GILSBAR',
member_id =left(member_id,10),
group_number= left(subgroup_number,7),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_294'

;

-- 'Rule 317 - Clone Catamaran BCBS NJ'

insert into clone_lead
select *, 'RULE_317' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name='RWTUNITE'
and subgroup_number IN ('UHH01100', 'UHH02100', 'UHH04100', 'UHH00105', 'UHH01105', 'UHH02300', 'UHH05300', 'UHH01350', 'UHH01400', 'UHH04400')

;
update clone_lead
set
carrier_name = 'BCBS NJ',
--member_id = 'KJP74'|| Right(policy_id_alt,7),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_317'
;
-- 'Rule 318 - Clone Catamaran BCBS NJ'

insert into clone_lead
select *, 'RULE_318' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name='RWTUNITE'
and subgroup_number IN ('UHH00102', 'UHH02102','UHH00202')

;
update clone_lead
set
carrier_name = 'BCBS NJ',
--member_id = 'UXI74'|| Right(policy_id_alt,7),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_318'
;

-- 'Rule 335 - Clone CVS_Caremark GOODYEAR RETIREE HC TRUST'

insert into clone_lead
select *, 'RULE_335' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name in ('GOODYEAR RETIREE HC TRUST','PNC FINANCIAL SERV GROUP')
or group_name like 'ARCONIC%') 

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
--member_id = 'YYP' || left(member_id,9), 
group_number = NULL,
group_name = NULL, 
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_335'
;

-- 'Rule 347 - Clone Catamaran RWTGROUP' -- DM3.7_Updates


insert into clone_lead
select *, 'RULE_347' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTGROUP'

;
update clone_lead
set
carrier_name = 'GROUP RESOURCES',
member_id = policy_id_alt,
group_number = Right(subgroup_number,4),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_347'
;

-- 'Rule 368 - Clone CVS_Caremark STATE OF FLORIDA PPO'

insert into clone_lead
select *, 'RULE_368' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'STATE OF FLORIDA PPO'

;
update clone_lead
set
carrier_name = 'BCBS FL',
--member_id = 'XJJ' || left(member_id,9),
group_number = NULL,
group_name = 'STATE ACCOUNT',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_368'
;

-- 'Rule 381 - Clone OptumRX UHCACIS01 STATE OF NEBRASKA'

insert into clone_lead
select *, 'RULE_381' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'UHCACIS01'
and group_name = 'STATE OF NEBRASKA'

;
update clone_lead
set
carrier_name = 'UNITED HEALTHCARE',
member_id = left(member_id,9),
group_number = left(group_desc,6),
group_name = 'STATE OF NEBRASKA',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_381'
;

-- 'Rule 388 - Clone CVS_Caremark TAYLOR BENEFIT RES SEI-9'

insert into clone_lead
select *, 'RULE_388' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'TAYLOR BENEFIT RES SEI-9'

;
update clone_lead
set
carrier_name = 'TAYLOR BENEFIT RESOURCE',
member_id = left(member_id,9),
group_number = left(member_id,4),
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_388'
;

-- 'Rule 392 - Clone Express_Scripts HEALTH ALLIANCE MEDICAL PLAN'

insert into clone_lead
select *, 'RULE_392' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'HEALTH ALLIANCE MEDICAL PLAN'

;
update clone_lead
set
carrier_name = 'HEALTH ALLIANCE MEDICAL PLAN',
--member_id = member_id || pbm_person_code,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_392'
;

-- 'Rule 406 - Clone CVS_Caremark Delco Trust'

insert into clone_lead
select *, 'RULE_406' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'DELCO TRUST'

;
update clone_lead
set
carrier_name = 'INDEPENDENCE BLUE CROSS',
--member_id = 'QCI' || left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_406'
;

-- 'Rule 409 - Clone CVS_Caremark REYES HOLDINGS HIGHMARK REYES HOLDINGS-HMRK BCBS REYES HOLDINGS, LLC'

insert into clone_lead
select *, 'RULE_409' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('REYES HOLDINGS HIGHMARK', 'REYES HOLDINGS-HMRK BCBS', 'REYES HOLDINGS, LLC')

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
--member_id = 'RHV' || left(member_id,9),
group_number = NULL,
group_name = 'REYES HOLDINGS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_409'
;

-- 'Rule 413 - Clone Express_Scripts UTSYSRX'

insert into clone_lead
select *, 'RULE_413' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'UTSYSRX'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
--member_id = 'UTS0' || left(member_id,8),
group_number = NULL,
group_name = 'THE UNIVERSITY OF TEXAS SYSTEM',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_413'
;
-- 'Rule 414 - Clone CVS_Caremark MI CONF TEAMSTERS WLF FND'

insert into clone_lead
select *, 'RULE_414' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MI CONF TEAMSTERS WLF FND'

;
update clone_lead
set
carrier_name = 'BCBS MI',
--member_id = 'KMT' || left(member_id,9), 
group_number = '71549',
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_414'
;

-- 'Rule 417 - Clone Catamaran Suffolk County EMHP'

insert into clone_lead
select *, 'RULE_417' from cob_lead_staging
where carrier_name = 'CATAMARAN'
AND policy_employer_name = 'SUFFOLK COUNTY EMHP'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
--member_id = 'CDK' || left(member_id,9),
group_number = '720059',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_417'
;

-- 'Rule 462 - Clone MedImpact LEGACY HEALTH SYSTEM'

insert into clone_lead
select *, 'RULE_462' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name = 'LEGACY HEALTH SYSTEM'

;
update clone_lead
set
carrier_name = 'PACIFICSOURCE',
--member_id = member_id || '0' || pbm_person_code,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_462'
;

-- 'Rule 484 - Clone Express_Scripts 35242RX WILLIS KNIGHTON HEALTHSYS'

insert into clone_lead
select *, 'RULE_484' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '35242RX'
and group_name = 'WILLIS KNIGHTON HEALTHSYS'

;
update clone_lead
set
carrier_name = 'GILSBAR',
--group_number = 'S' || left(group_number,4),
group_name = 'WILLIS KNIGHTON HEALTH SYSTEM',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_484'
;


-- 'Rule 534 - Clone Express_Scripts AK9A'

insert into clone_lead
select *, 'RULE_534' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AK9A'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
--member_id = CASE
--when group_name = 'RETIRED UNION OPEN' and left(coalesce(policy_ssn,''),3) = 'UVN' then policy_ssn
--when group_name = 'RETIRED UNION OPEN' and left(coalesce(policy_ssn,''),3) <> 'UVN' then 'AMD' || policy_ssn
--when coalesce(group_name,'') <> 'RETIRED UNION OPEN' and left(coalesce(member_id,''),3) <> 'UVN' then 'AMD' || member_id
--else member_id end,
group_number = NULL,
group_name = 'MERITOR, INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_534'
;

-- 'Rule 549 - Clone Catamaran NISSAN'

insert into clone_lead
select *, 'RULE_549' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'NISSAN'

;
update clone_lead
set
carrier_name = 'BCBS TN',
--member_id = 'NMU' || left(member_id, 9),
group_number = '82040',
group_name = 'NISSAN NORTH AMERICA INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_549'
;

-- 'Rule 554 - Clone CVS_Caremark INGRX-CT COMMERCIAL'

insert into clone_lead
select *, 'RULE_554' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-CT COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS CT',
--member_id = CASE
--when member_id like 'AN%' then 'TRN' || left(member_id, 9)
--else left(member_id, 10) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_554'
;
-- 'Rule 555 - Clone CVS_Caremark INGRX-GA COMMERCIAL'

insert into clone_lead
select *, 'RULE_555' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-GA COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
--member_id = CASE
--when member_id like 'AN%' then 'YCM' || left(member_id, 9)
--when member_id like 'SKG%' then member_id
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_555'
;
-- 'Rule 556 - Clone CVS_Caremark INGRX-IN COMMERCIAL'

insert into clone_lead
select *, 'RULE_556' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-IN COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS IN',
--member_id = CASE
--when member_id like 'AN%' then 'JIN' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_556'
;
-- 'Rule 557 - Clone CVS_Caremark INGRX-KY COMMERCIAL'

insert into clone_lead
select *, 'RULE_557' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-KY COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS KY',
--member_id = CASE
--when member_id like 'AN%' then 'KFQ' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_557'
;
-- 'Rule 558 - Clone CVS_Caremark INGRX-ME COMMERCIAL'

insert into clone_lead
select *, 'RULE_558' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-ME COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS ME',
--member_id = CASE
--when member_id like 'AN%' then left(member_id, 9)
--else left(member_id, 10) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_558'
;
-- 'Rule 559 - Clone CVS_Caremark INGRX-MO COMMERCIAL'

insert into clone_lead
select *, 'RULE_559' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-MO COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS MO',
--member_id = CASE
--when member_id like 'AN%' then 'OZA' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_559'
;
-- 'Rule 560 - Clone CVS_Caremark INGRX-OH COMMERCIAL'

insert into clone_lead
select *, 'RULE_560' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-OH COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
--member_id = CASE
--when member_id like 'AN%' then 'LHR' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_560'
;
-- 'Rule 561 - Clone CVS_Caremark INGRX-NH COMMERCIAL'

insert into clone_lead
select *, 'RULE_561' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-NH COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS NH',
--member_id = CASE
--when member_id like 'AN%' then 'EHK' || left(member_id, 9)
--else left(member_id, 10) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_561'
;

-- 'Rule 564 - Clone CVS_Caremark INGRX-VA COMMERCIAL'

insert into clone_lead
select *, 'RULE_564' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-VA COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS VA',
--member_id = CASE
--when member_id like 'AN%' then 'AGX' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_564'
;
-- 'Rule 565 - Clone CVS_Caremark INGRX-WI COMMERCIAL'

insert into clone_lead
select *, 'RULE_565' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-WI COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS WI',
--member_id = CASE
--when member_id like 'AN%' then 'RTB' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_565'
;
-- 'Rule 566 - Clone CVS_Caremark INGRX-COVA COMMERCIAL LC XU'

insert into clone_lead
select *, 'RULE_566' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-COVA COMMERCIAL'
--and (substring(member_id,8,2) = 'LC' or substring(member_id,8,2) = 'XU')

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS VA',
member_id = left(member_id, 9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_566'
;
-- 'Rule 567 - Clone CVS_Caremark INGRX-WICOINCO COMMERCIAL'

insert into clone_lead
select *, 'RULE_567' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-WICOINCO COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS WI',
--member_id = CASE
--when member_id like 'AN%' then 'PTV' || left(member_id, 9)
--else left(member_id, 9) end,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_567'
;

-- 'Rule 581 - Clone OptumRx PSI3637'

insert into clone_lead
select *, 'RULE_581' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'PSI3637'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
--member_id = 'JEA' || left(member_id, 9),
group_number = '238000',
group_name = 'HEALTHSELECT OF TEXAS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_581'
;
-- 'Rule 582 - Clone Catamaran SCUFCW LCL455A LCL455B'

insert into clone_lead
select *, 'RULE_582' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'SCUFCW'
and subgroup_number in ('LCL455A', 'LCL455B')

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
--member_id = 'UFW' || left(member_id, 12),
group_name = upper(policy_employer_name),
group_number = 'PB4607',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_582'
;

-- 'Rule 601 - Clone CVS_Caremark PSEG LONG ISLAND, AMERICAN WATER CDH, WEBMD'

insert into clone_lead
select *, 'RULE_601' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('PSEG LONG ISLAND', 'AMERICAN WATER CDH', 'WEBMD')

;
update clone_lead
set
carrier_name = 'BCBS NJ',
--member_id = 'NAT' || left(member_id, 9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_601'
;

-- 'Rule 615 - Clone Express_Scripts WINTHRP'

insert into clone_lead
select *, 'RULE_615' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WINTHRP'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
--member_id = 'WUC' || left(member_id, 8),
group_number = '377651',
group_name = 'NYU WINTHROP HOSPITAL',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_615'
;

-- 'Rule 636 - Clone Catamaran SOUTHERN OPERATORS'

insert into clone_lead
select *, 'RULE_636' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'SOUTHERN OPERATORS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
--member_id = case when left(policy_id,3) = 'QSJ' then 'QSJZ' || Right(policy_id,8)
--when left(policy_id,3) = 'QSG' then 'QSGZ' || Right(policy_id,8)
--else Right(policy_id,8) end,
group_number = NULL,
group_name = 'SOUTHERN OPERATORS HEALTH FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_636'
;
