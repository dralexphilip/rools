
insert into clone_lead
select *, 'RULE_22' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'APWU000';

--  'Rule 22 - Clone Express Scripts APWU000'



update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'APWU HEALTH PLAN',
member_id = NULL,
group_number = 'FEHBP',
group_name = 'APWU',
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_22';


insert into clone_lead
select *, 'RULE_23' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('L4TA', 'MASA', 'MDXA');


-- 'Rule 23 - Clone Express Scripts BCBS MA'



update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS MA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_23';



insert into clone_lead
select *, 'RULE_24' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number IN ('BCBSMROC', 'BCBSMRX1', 'MIBCNRX', 'BCNRXPD')
Or (subgroup_number = 'BCBSMAN' and coalesce(member_id,'p') <> coalesce(policy_ssn,'s'))) --Added 10/22/2019 per DM4.7_Week30_Updates TPLA-689
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
select *, 'RULE_25' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('BCTMAPD', 'BCTCOMM');


-- 'Rule 25 - Clone Express Scripts BCBS TN'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS TN',
member_id = (case when subgroup_number = 'BCTCOMM' then ('AKL' || member_id)
else member_id end),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_25';


insert into clone_lead
select *, 'RULE_26' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number IN ('KHYA', 'GH3A','KHXA','KJ2A','L4JA','L4SA','SSEU371')  --Added 'UFTWFRX','SSEU371' 8/10/2018
or (subgroup_number = 'UFTWFRX' and pbm_person_code = '01'))  --Moved UFTWFRX to separate line with PBMPerson Code Requirement 2/21/2019
and coalesce(group_name,'') not like '%PRESCRIPTION ONLY%'  --Added at Business Req 6/8/2018
;


-- 'Rule 26 - Clone Express Scripts -- '


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'EMBLEM HEALTH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_26'
;



insert into clone_lead
select *, 'RULE_27' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number in ('EXC11', 'EXC14', 'EXC15', 'EXLHPRX', 'EXLHXRX')
or group_name = 'EXCELLUS BLUECROSS BLUESH')
and coalesce(group_name,'') not like 'U ADMIN%'  --Added all below except UNIVERA 2/14/2019 per DM3.6_Updates
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
member_id = 'ASB' || left(member_id,9),
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
select *, 'RULE_28' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('HNRXS','HNMED','HNKAL','HNEXCHG')
;

-- 'Rule 28 - Clone Express Scripts HealthNow BCBS'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = case when group_name Like '%W%' then 'HEALTHNOW BCBS WNY' else 'HEALTHNOW BS NENY' end,
member_id = 'ZWF' || member_id,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_28';



insert into clone_lead
select *, 'RULE_29' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
--and (subgroup_number in ('GTEAGLE','HMRK001','KMTPHRM','SPBLUE1','SPBLUE2','SPBLUE3','UBCCFRX','YC8A') --Added GTEAGLE,UBCCFRX,YC8A 2/14/2019 DM3.7_Updates  --Removed these 2 lines 10/21/2019 per TPLA-520
--or (subgroup_number = 'DCSGRX9' and group_name like '%HIGHMARK%'))
and (subgroup_number in ('AAAECRX', 'DCSGRX9', 'GTEAGLE', 'HMRK001', 'KMTPHRM', 'NCCRX4U', 'SELMEDRX', 'SPBLUE1', 'SPBLUE3', 'UBCCFRX', 'YCBA') --Note from here through the rest of the where statement is complete rewrite per DM4.6_Week24_Updates TPLA-520  --'GTEAGLE' and 'NCCRX4U' added 10/21/2019 per DM4.6_Week26_Updates TPLA-550
or subgroup_number like '% %')
and (group_name in ('00177509', '00177511', 'FPH', 'GIANT EAGLE', 'HBG CENTRAL PA', 'HCA WESTERN PA', 'HCRX FPH', 'HCRX PA HHIC CENTRAL', 'HCRX PA HHIC WESTERN', 'HCRX PA KEYSTONE', 'NEPA', 'FREEDOM BLUE') --'GIANT EAGLE' added 10/21/2019 per DM4.6_Week26_Updates TPLA-550
or group_name like '%HIGHMARK%')
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
member_id = case when member_id Like '%001' then 'SLF' || member_id
when Right(member_id,1) in ('A','B') then member_id --Added 10/21/2019 per DM4.6_Week24_Updates TPLA-520
else null end,
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
select *, 'RULE_30' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('MMODRUG','MMOMDRX','MMOEXCH')
;

-- 'Rule 30 - Clone Express Scripts Medical Mutual'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MEDICAL MUTUAL',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_30'
;



insert into clone_lead
select *, 'RULE_31' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LWWAPDP'
;

-- 'Rule 31 - Clone Express Scripts Premera Lifewise of Washington'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'LIFEWISE OF WASHINGTON',
member_id = 'ZNG' || member_id,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_31'
;


insert into clone_lead
select *, 'RULE_33' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('BARAPDP','BCWAPDP') --Added BARAPDP 2/14/2019 DM3.6_Updates  --Removed HPWBCWA 5/30/2019 DM4.3_Week12_Updates
;


-- 'Rule 33 - Clone Express Scripts Premera BC WA'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = case
when group_name like '%AK%' then 'PREMERA BCBS AK'
when group_name like '%ALASKA%' then 'PREMERA BCBS AK'
else 'PREMERA BC WA' end,
member_id = 'MSJ' || member_id,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_33';


insert into clone_lead
select *, 'RULE_34' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('PHCMRCL','PHCMADB','PHEXADB','PHMEDCR');


-- 'Rule 34 - Clone Express Scripts Priority Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PRIORITY HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_34';



insert into clone_lead
select *, 'RULE_35' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AN9A';


-- 'Rule 35 - Clone Express Scripts Scan Health Plan'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SCAN HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_35';

insert into clone_lead
select *, 'RULE_36' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SAMBARX';


-- 'Rule 36 - Clone Express Scripts Samba'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SAMBA',
group_number = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_36';


insert into clone_lead
select * , 'RULE_37' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('NDPA','SVHA');


-- 'Rule 37 - Clone Express Scripts Sanford'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SANFORD HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_37';


insert into clone_lead
select *, 'RULE_38' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('L4NA','MNUA');


-- 'Rule 38 - Clone Express Scripts UCARE'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'UCARE',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_38';



insert into clone_lead
select *, 'RULE_39' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('L4GA','L4YA','L9BA','PMDA','PMDC'); --Added PMDA and L4GA 2/14/2019 DM3.6_Updates


-- 'Rule 39 - Clone Express Scripts UPMC'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'UPMC',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_39';


insert into clone_lead
select *, 'RULE_40' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'THPMEDI';
--and subgroup_number in ('THPMEDI','3602','THPWVMC') --Removed 2 Groups 8/10/2018 per COB Request


-- 'Rule 40 - Clone Express Scripts THPUOV'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'THE HEALTH PLAN OF UPPER OHIO VALLEY',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_40';




insert into clone_lead
select *, 'RULE_40B' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '3602';


-- 'New Rule - Rule 40B - Clone Express Scripts THPUOV' -- Added 8/10/2018

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'THE HEALTH PLAN OF UPPER OHIO VALLEY',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_40B';


--update cob_lead_staging
--set group_name = (select Group_Name
--from public.benesys_decode
--where public.benesys_decode.Group_Number = cob_lead_staging.group_number)
--where carrier_name = 'BENESYS'
--and cob_lead_staging.group_number in (select Group_Number
--from public.benesys_decode);


-- 'Rule 41 - Benesys Group Names'

----PRINT N'Rule 42 - clone Catamaran AmeriHealth'  --Removed 7/24/2019 TPLA-628
--insert into clone_lead
--select * from cob_lead_staging
--where carrier_name = 'CATAMARAN'
--and (group_name like 'AMERIHEALTH ADMIN%'
--	or policy_employer_name = 'AMERIHEALTH ADMINISTRATOR') --Added 1/8/2019 DM3.6_Updates

--update clone_lead
--set
--	pbm_bin  = NULL,
--	pbm_pcn  = NULL,
--  carrier_name = 'AmeriHealth Administrators', --Changed from AmericHealth Administrators to AmeriHealth Administrators 1/8/2019 DM3.6_Updates
--  member_id = 'YXT' || left(member_id,8), --Added prefix YXT 1/8/2019 DM3.6_Updates
--	group_number = NULL,
--	group_name = NULL,
--	plan_type = case
--		when plan_type::text like '%PA%' then '{MM}'
--		when plan_type::text like '%MD%' then '{MC}'
--		else plan_type end

--Insert Into #COBLead_Staging
--(LeadID, RosterID, Enrollee_ID, member_id, policy_ssn, PolLName, PolFName, PolDOB, PolAddress, PolCity, PolState, PolZip, group_number, subgroup_number, group_name, group_desc, policy_employer_name, EffDate, TermDate, member_ssn, MemLName, MemFName, MemMName, MemDOB, MemSex, MemAddress, member_city, member_state, member_zip, SourceID, CoverageCodes, WorkType, carrier_name, ContactName, ContactNumber, HighPriority, AttachmentID, DateReceived, pbm_bin , pbm_pcn , IgnoreError, filename, RosterLoadDate, Score, CarrierCode, plan_type, Submitter, PTGroup, PolMName, pbm_person_code, MemRelationship, LOB, DivisionCode, policy_id, PolSex, medical_name,clone,policy_id_alt,member_id_alt)
--Select LeadID, RosterID, Enrollee_ID, member_id, policy_ssn, PolLName, PolFName, PolDOB, PolAddress, PolCity, PolState, PolZip, group_number, subgroup_number, group_name, group_desc, policy_employer_name, EffDate, TermDate, member_ssn, MemLName, MemFName, MemMName, MemDOB, MemSex, MemAddress, member_city, member_state, member_zip, SourceID, CoverageCodes, WorkType, carrier_name, ContactName, ContactNumber, HighPriority, AttachmentID, DateReceived, pbm_bin , pbm_pcn , IgnoreError, filename, RosterLoadDate, Score, CarrierCode, plan_type, Submitter, PTGroup, PolMName, pbm_person_code, MemRelationship, LOB, DivisionCode, policy_id, PolSex, medical_name,'Y',policy_id_alt,member_id_alt --
--from #cloneLead

--TRUNCATE TABLE #cloneLead



insert into clone_lead
select * , 'RULE_43' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like '%ASURIS%';


-- 'Rule 43 - Clone Catamaran Asuris'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ASURIS NORTHWEST HEALTH',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_43';


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
member_id = 'ABD' || left(member_id,9),
group_number = NULL,
group_name = upper(group_desc),
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_44';


insert into clone_lead
select * , 'RULE_45' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'BENEFIT ADMIN SYSTEMS LLC';


-- 'Rule 45 - Clone Catamaran Benefit Admin'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BENEFIT ADMIN SYSTEMS',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_45';


insert into clone_lead
select *, 'RULE_46' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'DELTA HEALTH SYSTEMS';


-- 'Rule 46 - Clone Catamaran Delta Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'DELTA HEALTH SYSTEMS',
member_id = left(member_id,8),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_46';


insert into clone_lead
select *, 'RULE_47' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and (policy_employer_name like 'EBAM%' or policy_employer_name like 'EBA&M%');


-- 'Rule 47 - Clone Catamaran EBA&M'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'EBA&M',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_47';

insert into clone_lead
select *, 'RULE_48' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and (policy_employer_name like 'HAMP %' or group_number like 'HA00%');


-- 'Rule 48 - Clone Catamaran HAMP'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTH ALLIANCE MEDICAL PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_48';


insert into clone_lead
select *, 'RULE_49' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and (policy_employer_name like 'HAP ALLIANCE%' or
policy_employer_name like 'HAP COMMERCIAL%' or
policy_employer_name like 'HAPMEDD%' or
policy_employer_name like 'HAPQ%' or
group_number like 'HAPA%');


-- 'Rule 49 - Clone Catamaran Health Alliance Plan of Michigan'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTH ALLIANCE PLAN OF MICHIGAN',
member_id = case when policy_employer_name like 'HAPMEDD%' then NULL else member_id end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_49';


insert into clone_lead
select *, 'RULE_50' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'HEALTHCOMP%'; --Added wildcard 8/10/2018


-- 'Rule 50 - Clone Catamaran Healthcomp'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTHCOMP',
member_id = left(member_id,9), --8/10/2018 changed from PolSSn to Left(member_id,9) per COB Req
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_50';


insert into clone_lead
select *, 'RULE_51' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'IBC%'
and coalesce(group_name,'') <> 'BLUE CHIP';  --Added 2/14/2019 DM3.6_Updates


-- 'Rule 51 - Clone Catamaran Independence Blue Cross'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INDEPENDENCE BLUE CROSS',
member_id = 'QCI' || left(member_id,12),
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_51';


insert into clone_lead
select * , 'RULE_52' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'KELSEYCARE%';


-- 'Rule 52 - Clone Catamaran KelseyCare'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'KELSEYCARE ADVANTAGE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_52';


insert into clone_lead
select *, 'RULE_53' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'MEMORIAL HERMANN%';


-- 'Rule 53 - Clone Catamaran Memorial Hermann'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MEMORIAL HERMANN HEALTH INSURANCE',
--member_id = NULL, --Removed 2/14/2019 DM3.7_Updates
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_53';


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
member_id = case when left(member_id,1) = '9' then NULL else member_id end,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_54';


insert into clone_lead
select *, 'RULE_55' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_number like 'PHS%';


-- 'Rule 55 - Clone Catamaran Presbyterian'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PRESBYTERIAN HEALTH PLAN',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_55';


insert into clone_lead
select *, 'RULE_56' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and (group_number like '%QCA %' or policy_employer_name like 'QUALCHOICE%');


-- 'Rule 56 - Clone Catamaran QualChoice'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'QUALCHOICE HEALTH INSURANCE',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_56';


insert into clone_lead
select *, 'RULE_57' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'REGENCE BCBS OF O%';


-- 'Rule 57 - Clone Catamaran Regence BCBS OR'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'REGENCE BCBS OR',
member_id = 'YVA' || member_id,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_57';


insert into clone_lead
select *, 'RULE_58' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'REGENCE BCBS OF U%';


-- 'Rule 58 - Clone Catamaran Regence BCBS UT'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'REGENCE BCBS UT',
member_id = 'YVA' || member_id,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_58';


insert into clone_lead
select *, 'RULE_59' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'REGENCE BS OF I%';


-- 'Rule 59 - Clone Catamaran Regence BS ID'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'REGENCE BS ID',
member_id = 'YVA' || member_id,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_59';


insert into clone_lead
select * , 'RULE_60' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'REGENCE BS W%';


-- 'Rule 60 - Clone Catamaran Regence BS WA'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'REGENCE BS WA',
member_id = 'YVA' || member_id,
group_number = subgroup_number,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_60';


insert into clone_lead
select * , 'RULE_61' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'REGENCE M%';


-- 'Rule 61 - Clone Catamaran Regence Others'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = case when member_state = 'OR' then 'Regence BCBS OR'
when member_state = 'UT' then 'REGENCE BCBS UT'
when member_state = 'ID' then 'REGENCE BS ID'
when member_state = 'WA' then 'REGENCE BS WA'
else 'REGENCE BCBS' end,
member_id = 'YVA' || member_id,
group_number = subgroup_number,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_61';


insert into clone_lead
select * , 'RULE_62' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'SAMARITAN%';


-- 'Rule 62 - Clone Catamaran Samaritan'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SAMARITAN HEALTH',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_62';


insert into clone_lead
select *, 'RULE_63' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'ALLIED BENEFIT%';

-- 'Rule 63 - Clone CVS Caremark Allied Benefit Systems'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ALLIED BENEFIT SYSTEMS',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_63';


insert into clone_lead
select *, 'RULE_64' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like '%AFFINITY MEDICARE%' or group_name like '%AFFINITY ESS%'); --Added wildcards before both 2/14/2019 DM3.7_Updates


-- 'Rule 64 - Clone CVS Caremark Affinity Health Plan'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AFFINITY HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' THEN '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_64';


insert into clone_lead
select *, 'RULE_65' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'AVMED%';


-- 'Rule 65 - Clone CVS Caremark AvMed'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AVMED',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_65';


insert into clone_lead
select *, 'RULE_66' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('FEP','SERVICE BENE PLAN-BCBSA');


-- 'Rule 66 - Clone CVS Caremark BCBS FEP'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS FEP',
member_id = left(member_id,9),
group_number = NULL,
group_name = 'FEDERAL EMPLOYEE PROGRAM',
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_66';


insert into clone_lead
select *, 'RULE_67' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name = 'BCBS SOUTH CAROLINA' or group_name like 'BCBSSC%' or group_name like 'SC NA BC%') --Added 'SC NA BC%' 1/8/2019 DM3.6_Updates
and group_name not like 'BCBSSC-PAI%' and group_name not like 'BCBSSC PAI ESS CARE%'; --Added at Business request 6/8/2018


-- 'Rule 67 - Clone CVS Caremark BCBS SC'


update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS SC',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_67';


insert into clone_lead
select *, 'RULE_68' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BENEFIT PLAN ADM-ROANOKE';


-- 'Rule 68 - Clone CVS Caremark Benefit Plan Admin'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BENEFIT PLAN ADMINISTRATORS',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_68';


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
member_id = case when left(member_id,1) = '8' then 'YWW' || member_id else NULL end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_69';


insert into clone_lead
select *, 'RULE_70' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CDPHP%'
and coalesce(group_name,'') <> 'CDPHP GOVERNMENT PLANS';


-- 'Rule 70 - Clone CVS Caremark CDPHP'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAPITAL DISTRICT PHYSICIAN''S HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_70';


insert into clone_lead
select *, 'RULE_71' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'CARESOURCE HIX%' or
group_name like 'CARESOURCE MAPD%' or
group_name like 'CARESOURCE WV EX%');


-- 'Rule 71 - Clone CVS Caremark Caresource'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CARESOURCE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_71';



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
select * , 'RULE_74' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'COASTAL TPA';


-- 'Rule 74 - Clone CVS Caremark Coastal TPA'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'COASTAL TPA',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_74';



insert into clone_lead
select * , 'RULE_75' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'DAKOTACARE%'
or group_name like 'DAK LG%'
or group_name like 'DAK SMALL%');


-- 'Rule 75 - Clone CVS Caremark Dakotacare'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'DAKOTACARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_75';


insert into clone_lead
select *, 'RULE_76' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'DELTA HEALTH%';


-- 'Rule 76 - Clone CVS Caremark Delta Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'DELTA HEALTH SYSTEMS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_76';


insert into clone_lead
select *, 'RULE_77' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'FALLON%';


-- 'Rule 77 - Clone CVS Caremark Fallon Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'FALLON HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_77';


insert into clone_lead
select * , 'RULE_78' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'FIDELIS ESSENTIAL%' or
group_name like 'FIDELIS EXCHANGE%' or
group_name like 'FIDELIS COMMERCIAL%' or
group_name like 'FIDELIS OFF EXC%');


-- 'Rule 78 - Clone CVS Caremark Fidelis'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'FIDELIS CARE, INC.',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_78';


insert into clone_lead
select *, 'RULE_79' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'GHP OH KY NC MEDD%' or
group_name like 'GHP PA MEDD%');


-- 'Rule 79 - Clone CVS Caremark Gateway'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GATEWAY HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_79';


insert into clone_lead
select *, 'RULE_80' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'GROUP & PENSION A%';


-- 'Rule 80 - Clone CVS Caremark GPA'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GROUP & PENSION ADMINISTRATORS (GPA)',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = '{MM}'
where match_carrier_rule_id_extra = 'RULE_80';


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
member_id = 'XLA' || left(member_id,13),  --Changed from NULL to 'XLA' || Left(member_id,13) 8/10/2018
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_81';



insert into clone_lead
select *, 'RULE_82' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'HEALTH NET%' --Removed Space after Net 5/30/2019 DM19_Week8_Updates
and group_name not like '%MP-%'
--and group_name not like '%CNC DIVISION CORP HN%'  --Removed 5/30/2019 DM19_Week8_Updates
and group_name not like '%CNC CENTENE CORP HN%' --Added 2/14/2019 DM3.6_Updates
and group_name not like '%SIP HNPS%';


-- 'Rule 82 - Clone CVS Caremark Health Net'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTH NET',
--member_id = left(member_id,9),  --Removed 5/30/2019 DM19_Week8_Updates
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_82';


insert into clone_lead
select *, 'RULE_83' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'HF QHP%' or
group_name like 'HF NY MCR%');


-- 'Rule 83 - Clone CVS Caremark Healthfirst'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTHFIRST NEW YORK',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_83';


insert into clone_lead
select *, 'RULE_84' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like '%THE LOOMIS%';


-- 'Rule 84 - Clone CVS Caremark Loomis'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'THE LOOMIS COMPANY',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_84';


insert into clone_lead
select * , 'RULE_86' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'MPHC - GA%';


-- 'Rule 86 - Clone CVS Caremark Martin'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MARTIN''S POINT HEALTH CARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_86';


insert into clone_lead
select * , 'RULE_87' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MPHC - USFHP';


-- 'Rule 87 - Clone CVS Caremark Martin'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MARTIN''S POINT HEALTH CARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{TR}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_87';


insert into clone_lead
select *, 'RULE_88' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'IFB IA%' or
group_name like 'IFB KS%' or
group_name like 'IFB MN%' or
group_name like 'IFB ND%' or
group_name like 'IFB NE%' or
group_name like 'IFB SD%' or
group_name like 'IFB WI%');


-- 'Rule 88 - Clone CVS Caremark Medica2'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MEDICA HEALTH PLANS',
member_id = left(member_id,10),
group_number = 'IFB',
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_88';


insert into clone_lead
select *, 'RULE_89' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'COMM LARGE GROUP M%' or
group_name like 'COMM SMALL GROUP M%' or
group_name = 'COMM MSI' or
group_name like 'SRS MHP%' or
group_name like 'SRS MIC%');


-- 'Rule 89 - Clone CVS Caremark Medica (UHC)'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MEDICA HEALTH PLANS',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_89';



insert into clone_lead
select *, 'RULE_90' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('METROPLUS HP EX', 'METROPLUS HP GOLD', 'METROPLUS HP EXCH', 'METROPLUS HP SHOP') --Changed from like 'METROPLUS HP EX%' to In statement and added 'METROPLUS HP GOLD', 'METROPLUS HP EXCH' 10/22/2019 per DM4.7_Week28_Updates TPLA-629
;


-- 'Rule 90 - Clone CVS Caremark MetroPlus'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
carrier_name = 'METROPLUS HEALTH PLAN',
member_id = left(member_id,9), --Changed from Null to Left(member_id,9) 10/22/2019 per DM4.7_Week28_Updates TPLA-629
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_90';

insert into clone_lead
select *, 'RULE_91' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'MOLINA MARKETPLACE%';


-- 'Rule 91 - Clone CVS Caremark Molina'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MOLINA HEALTHCARE',
member_id = left(member_id,10),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_91';


insert into clone_lead
select *, 'RULE_92' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'MVP ASO%' or
group_name = 'MEDICARE D HMO WEST' or     --Added 2/14/2019 DM3.7_Updates
group_name = 'MVP MEDICARE D PPO' or	--Added 2/14/2019 DM3.7_Updates
group_name like 'MVP NH%' or
group_name like 'MVP NY INSURED%' or
group_name like 'MVP NY OFF%' or
group_name like 'MVP NY ON%' or
group_name like 'MVP VT%');


-- 'Rule 92 - Clone CVS Caremark MVP'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MVP HEALTH CARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_92';


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
member_ssn = case when Right(rtrim(member_id),1) <> 'A' then Null else member_ssn end,
policy_ssn = case when Right(rtrim(member_id),1) = 'A' then left(member_id,9)
else NULL end,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_93';


insert into clone_lead
select *, 'RULE_94' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like '%NEIGHBORHOOD HEALTH PLAN%' or
group_name like 'NHPMA%')
and member_id like 'NHP%'  --Added 2/14/2019 DM3.6_Updates
;


-- 'Rule 94 - Clone CVS Caremark Neighborhood Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'NEIGHBORHOOD HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_94'
;


insert into clone_lead
select * , 'RULE_95' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'OSCAR %';


-- 'Rule 95 - Clone CVS Caremark Oscar'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'OSCAR INSURANCE CORP',
member_id = left(member_id,11),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_95';


insert into clone_lead
select *, 'RULE_96' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'PACIFICSOURCE%' or
group_name like 'PSM H%');


-- 'Rule 96 - Clone CVS Caremark PacificSource'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PACIFICSOURCE', --CHANGED FROM PACIFICSOURCE ADMINISTRATORS TO PACIFICSOURCE 10/21/2019 PER DM4.6_WEEK24_UPDATES TPLA-520
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_96';


insert into clone_lead
select * , 'RULE_97' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'PARAMOUNT COMM%' or
group_name like 'PARAMOUNT EXC%' or --changed from 'PARAMOUNT E%' to 'PARAMOUNT EXC%' 8/10/2018
group_name like 'PARAMOUNT M%' or
group_name like 'PARAMOUNT N%');


-- 'Rule 97 - Clone CVS Caremark Paramount'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PARAMOUNT INSURANCE COMPANY',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_97';


insert into clone_lead
select *, 'RULE_98' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'PEOPLES HEALTH MEDICARE' --Changed from Peoples Health% to Peoples Health Medicare 2/14/2019 DM3.6_Updates
;


-- 'Rule 98 - Clone CVS Caremark Peoples Health'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PEOPLES HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_98';


insert into clone_lead
select *, 'RULE_99' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'PIEDMONT C%'
or group_name like 'PIEDMONT ON%');


-- 'Rule 99 - Clone CVS Caremark Piedmont'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PIEDMONT COMMUNITY HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_99';


insert into clone_lead
select * , 'RULE_100' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'RURAL LETTER%';


-- 'Rule 100 - Clone CVS Caremark Rural Letter'

update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'RURAL LETTER CARRIERS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_100';

----------   Note:   after this point, the comment about what rule it is ABOVE the sql, not below it.

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
group_name in ('NETWORK HEALTH QHP','NHPMA COMMERCIAL')) --Added 2/14/2019 DM3.6_Updates


;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'TUFTS HEALTH PLAN',
member_id = case when length(member_id)=9 then member_id || '01' else left(member_id,11) end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_101'

;
-- 'Rule 102 - Clone CVS Caremark Universal American'

insert into clone_lead
select *, 'RULE_102' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'UNIVERSAL AMERICAN H%'
or group_name like 'UNIV AMER MAPD%')  --Added 2/14/2019 DM3.6_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'UNIVERSAL AMERICAN - WELLCARE',
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_102'

;
-- 'Rule 103 - Clone CVS Caremark USHEALTH Group'

insert into clone_lead
select * , 'RULE_103' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'VPS - USHEALTH GROUP'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'USHEALTH GROUP',
member_id = left(member_id,10),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_103'

;
-- 'Rule 104 - Clone CVS Caremark Viva Health'

insert into clone_lead
select *, 'RULE_104' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'VIVA H%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'VIVA HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_104'

;
-- 'Rule 105 - Clone CVS Caremark WellCare'

insert into clone_lead
select *, 'RULE_105' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like '%WELLCARE MAPD%'
or group_name like 'WELLCARE%HIX'  --Changed from group_name = 'WELLCARE KY HIX' and group_name = 'WELLCARE NY HIX' to group_name like 'WELLCARE%HIX' 8/10/2018
or group_name = 'WELLCARE BHP'  --Added these four 8/10/2018
or group_name like '%WELLCARE LPPO%'
or group_name like 'WELLCARE NJ%'
or group_name like 'WELLCARE PART B%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WELLCARE HEALTH PLANS',
member_id = left(member_id,8),  --Removed 8/10/2018  -Added back in 2/14/2019 DM3.6_Updates (Still in Data Match Roadmap this way at this time)
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_105'

;
-- 'Rule 106 - Clone CVS Caremark Wellcare Windsor'

insert into clone_lead
select *, 'RULE_106' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'WELLCARE WINDSOR H%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WINDSOR HEALTH PLAN - WELLCARE',
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_106'

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
member_id = 'WMA' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_107'

;
-- 'Rule 108 - Clone Delta Dental BCBS MS'

insert into clone_lead
select *, 'RULE_108' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name = 'BCBSMS'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS MS',
member_id = 'YAQ' || member_id,
group_number = NULL,
group_name = NULL,
plan_type = '{MM}'
where match_carrier_rule_id_extra = 'RULE_108'

;
-- 'Rule 110 - Clone Delta Dental HealthSun'

insert into clone_lead
select * , 'RULE_110' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'HEALTHSUN H%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTHSUN HEALTH PLANS',
member_id = left(member_id,8),
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_110'

;
-- 'Rule 111 - Clone Delta Dental Kaiser GA'

insert into clone_lead
select * , 'RULE_111' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and (group_name = 'KAISER FOUNDATION HLTH PLN GA' or
group_name like 'KAISER GA%' or
group_name = 'KFHP GEORGIA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF GEORGIA',  --CHANGED 8/10/2018
group_number = NULL,
group_name = NULL,
plan_type = '{HM}'
where match_carrier_rule_id_extra = 'RULE_111'

;
-- 'Rule 112 - Clone Delta Dental Kaiser Atlantic'

insert into clone_lead
select * ,'RULE_112' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name = 'KAISER ATLANTIC (DELTACARE)'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF GEORGIA',  --CHANGED 8/10/2018
group_number = NULL,
group_name = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_112'

;
-- 'Rule 113 - Clone Delta Dental Viva Health'

insert into clone_lead
select *, 'RULE_113' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'VIVA%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'VIVA HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = '{MM}'
where match_carrier_rule_id_extra = 'RULE_113'

;
-- 'Rule 115 - Clone MedImpact Geisinger'

insert into clone_lead
select *, 'RULE_115' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like 'GEISINGER%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GEISINGER HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_115'

;
-- 'Rule 116 - Clone MedImpact MDWise'

insert into clone_lead
select *, 'RULE_116' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like 'MDWISE%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MDWISE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_116'

;
-- 'Rule 117 - Clone MedImpact Northwest Administrators'

insert into clone_lead
select *, 'RULE_117' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like '%NORTHWEST ADMIN%'


;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'NORTHWEST ADMINISTRATORS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_117'
;

-- 'Rule 118 - Clone MedImpact SummaCare'

insert into clone_lead
select *, 'RULE_118' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and (group_name like '%SUMMACARE%'
or group_name = 'H3660') --Added H3660 2/14/2019 DM3.6_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SUMMACARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_118'

;
-- 'Rule 119 - Clone MedImpact Sutter Health'

insert into clone_lead
select *, 'RULE_119' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like 'SUTTER HEALTH%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SUTTER HEALTH PLUS',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_119'

;
-- 'Rule 120 - Clone Express Scripts EBA&M'

insert into clone_lead
select *, 'RULE_120' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'QEBA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'EBA&M',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_120'

;
-- 'Rule 121 - Clone Catamaran EBA&M' -- Added 8/10/2018


insert into clone_lead
select *, 'RULE_121' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and (subgroup_number like 'EBAM%'
or subgroup_number like 'EBA&M%'
or medical_name in ('RWTEBAMPB','RWTEBAM'))

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'EBA&M',
member_id = left(member_id,11),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_121'

;
-- 'Rule 122 - Clone Express Scripts CareFirst BCBS'

insert into clone_lead
select * , 'RULE_122' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and ((subgroup_number in ('CSRAINC', 'RX4CCPS') --Changed CSRA1RX to RX4CCPS 1/8/2019 DM3.6_Updates
and group_name like '%CAREFIRST%') --Changed from = Carefirst to like Carefirst 1/8/2019 DM3.6_Updates
or (subgroup_number = 'CSRA1RX' --Added here to end of statement 1/8/2019 DM3.6_Updates
and (group_name like '%CAREFIRST%' or group_name like '%CFIRST%' or group_name like '%CSRA CFIRST%'))
or (subgroup_number = 'JOHNSHOPKINSRX'
and (group_name like '%CAREFIRST%' or group_name like 'JHU BCBS%'))
or subgroup_number in ('SODEXO', 'BLTA')) --Added 10/21/2019 per DM4.6_Week26_Updates TPLA-550

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAREFIRST BCBS',
member_id = 'CAA' || policy_ssn, --Changed from Null to CAA || policy_ssn 1/8/2019 DM3.6_Updates
group_number = NULL,
group_name = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_122'

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
or (group_name like 'CF NASCO ASO%' and group_name <> 'CF NASCO ASO F2 T16 NR')) --Added this line 5/30/2019 DM19_Week8_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAREFIRST BCBS',
member_id = 'CAA' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_123'

;
-- 'Rule 124 - Clone CVS Caremark Carefirst BCBS'

insert into clone_lead
select *, 'RULE_124' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and subgroup_number like 'CF-%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CAREFIRST BCBS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_124'

;
-- 'Rule 125 - Clone Express Scripts BCBS LA'

insert into clone_lead
select *, 'RULE_125' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BSLA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BCBS LA',
--member_id = NULL,  --Removed 4/17/2019 per DM4.4_Week15_Updates
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_125'

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
member_id = 'ZIA' || left(policy_ssn,9),
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
member_id = 'CQM' || left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_127'

;
-- 'Rule 128 - Clone Express Scripts HMAA'

insert into clone_lead
select *, 'RULE_128' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('NDEA', 'N89A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HAWAII MEDICAL ASSURANCE ASSOC (HMAA)',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_128'

;
-- 'Rule 129 - Clone Express Scripts KelseyCare'

insert into clone_lead
select * , 'RULE_129' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'MCFARX1'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'KELSEYCARE ADVANTAGE',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%PM%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_129'

;
-- 'Rule 130 - Clone Express Scripts Meritain'

insert into clone_lead
select *, 'RULE_130' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('HCRMCRX','CNSA','BEDA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MERITAIN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_130'

;
-- 'Rule 131 - Clone Express Scripts Mutual of Omaha'

insert into clone_lead
select *, 'RULE_131' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'MMSA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MUTUAL OF OMAHA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MS}'
when plan_type::text like '%PM%' then '{MS}'
when plan_type::text like '%MD%' then '{MS}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_131'

;
-- 'Rule 132 - Clone Express Scripts Western Health'

insert into clone_lead
select *, 'RULE_132' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WHA3333'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WESTERN HEALTH ADVANTAGE',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_132'

;
-- 'Rule 133 - Clone Express Scripts WPS Health'

insert into clone_lead
select * , 'RULE_133' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WPS88','WPSPDP')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WPS HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_133'

;
-- 'Rule 134 - Clone Express Scripts SCAN Health Plan'

insert into clone_lead
select *, 'RULE_134' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('AN9A', 'L53A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'SCAN HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_134'

;
-- 'Rule 135 - Clone Express Scripts Univera'

insert into clone_lead
select *, 'RULE_135' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('EXLHPRX', 'EXLHXRX')  --Removed 'EXC11', 'EXC14', 'EXC15' 2/14/2019 DM3.6_Updates
and (group_name like 'U ADMIN%'  --Removed '%UNIVERA%' and added the rest 2/14/2019 DM3.6_Updates
or group_name like 'U INDIVIDUAL%'
or group_name like 'U SMALL%'
or group_name like 'U ESSENTIAL%'
or group_name like 'U EXPERIENCE%'
or group_name like 'U HARP'
or group_name like 'U MINIMUM%'
or group_name like 'UNIV S CHOICE%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'UNIVERA HEALTHCARE',
--member_id = NULL,  Removed 2/14/2019 DM3.6_Updates
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_135'

;
-- 'Rule 136 - Clone Catamaran Common Ground'

insert into clone_lead
select *, 'RULE_136' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'COMMON GROUND HLTCH COOP'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'COMMON GROUND HEALTHCARE COOP',
group_name = NULL,
group_number = NULL, --Added 2/14/2019 DM3.7_Updates
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_136'

;
-- 'Rule 137 - Clone Catamaran Friday Health'

insert into clone_lead
select * ,'RULE_137' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'SAN LUIS%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'FRIDAY HEALTH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_137'

;
-- 'Rule 138 - Clone Catamaran Health New England'

insert into clone_lead
select *, 'RULE_138' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'HEALTH NEW ENGLAND - PROD'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTH NEW ENGLAND',
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_138'

;
-- 'Rule 139 - Clone Catamaran Health Tradition'

insert into clone_lead
select *, 'RULE_139' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name in ('MAYO EMPLOYEES','HEALTH TRADITION')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTH TRADITION HEALTH PLAN',
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_139'

;
-- 'Rule 140 - Clone CVS Allegiance Benefit'

insert into clone_lead
select * , 'RULE_140' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'ALLEGIANCE BPM%' --Both changed from group_desc to group_name 2/14/2019 DM3.7_Updates
or group_name like 'ALLEGIANCE MHN%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ALLEGIANCE BENEFIT PLAN MANAGEMENT',
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_140'

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
member_id = case when member_id like 'S%' then Substring(member_id,2,(length(member_id)-3)) else left(member_id,(length(member_id)-2)) end,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_141'

;
-- 'Rule 142 - Clone CVS ArchCare Advantage'

insert into clone_lead
select *, 'RULE_142' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'ARCHCARE ADVANTAGE MAPD'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ARCHCARE ADVANTAGE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_142'

;
-- 'Rule 143 - Clone CVS Avera Health Plan'

insert into clone_lead
select * , 'RULE_143' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_desc like 'AHP %'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AVERA HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_143'

;
-- 'Rule 144 - Clone CVS Benefit Plan Administrators (WI)'

insert into clone_lead
select *, 'RULE_144' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BENEFIT PLAN ADMINISTRATO'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BENEFIT PLAN ADMINISTRATORS (WI)',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_144'

;
-- 'Rule 145 - Clone CVS Bright Health Plan'

insert into clone_lead
select *, 'RULE_145' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_number like 'BRIGHT HEALTH%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BRIGHT HEALTH PLAN',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_145'

;
-- 'Rule 146 - Clone CVS Central States Health Fund'

insert into clone_lead
select *, 'RULE_146' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('CENTRAL STATES HEALTH FUND','CENTRAL STATES HLTH FND') --Added CENTRAL STATES HLTH FND 2/14/2019 DM3.7_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CENTRAL STATES HEALTH FUND',
member_id = NULL,
group_number = NULL,
group_name = 'CENTRAL STATES BENEFITS FUNDS', --Changed from Null to Central States Benefits Funds 2/14/2019 DM3.7_Updates
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_146'

;
-- 'Rule 147 - Clone CVS Clover Health'

insert into clone_lead
select * ,'RULE_147' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CLOVER HEALTH%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CLOVER HEALTH',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_147'

;
-- 'Rule 148 - Clone CVS Combined Benefits Administrators'

insert into clone_lead
select *, 'RULE_148' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'COMpbm_bin ED BENEFITS ADMIN'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'COMBINED BENEFITS ADMINISTRATORS',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_148'

;
-- 'Rule 149 - Clone CVS Covenant Administrators'

insert into clone_lead
select *, 'RULE_149' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'COVENANT ADMINISTRATORS'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'COVENANT ADMINISTRATORS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_149'

;
-- 'Rule 150 - Clone CVS FamilyCare Health'

insert into clone_lead
select *, 'RULE_150' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'FAMILYCARE MEDICARE'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'FAMILYCARE HEALTH PLANS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_150'

;
-- 'Rule 151 - Clone CVS Fox Everett'

insert into clone_lead
select *, 'RULE_151' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like '%RXBENEFITS/FOX EVERETT%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'FOX EVERETT',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_151'

;
-- 'Rule 152 - Clone CVS Group Administrators'

insert into clone_lead
select *,'RULE_152' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'GROUP ADMINISTRATORS, LTD'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GROUP ADMINISTRATORS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_152'

;
-- 'Rule 153 - Clone CVS Group Benefit Services'

insert into clone_lead
select *, 'RULE_153' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'GROUP BENEFIT SERVICES'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GROUP BENEFIT SERVICES',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_153'

;
-- 'Rule 154 - Clone CVS Healthcomp'

insert into clone_lead
select *, 'RULE_154' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('HEALTHCOMP','HEALTHCOMP (11)')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'HEALTHCOMP',
member_id = policy_ssn,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_154'

;
-- 'Rule 155 - Clone CVS University Health Plans'

insert into clone_lead
select *, 'RULE_155' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'IUH COMM%'
or group_name like 'IUH EMP%'
or group_name like 'IUH LARGE%'
or group_name like 'IUH MEDICARE - PART B'
or group_name like 'IUH SMALL%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INDIANA UNIVERSITY HEALTH PLANS',
--member_id = NULL,  --Removed at Business request 6/8/2018
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_155'

;
-- 'Rule156New - Clone CVS Integra Admin Group'

insert into clone_lead
select *, 'RULE_156' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'INTEGRA ADMIN GROUP%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INTEGRA ADMIN GROUP',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_156'

;
-- 'Rule 157 - Clone CVS Insurance Management Administrators'

insert into clone_lead
select * , 'RULE_157' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INSURANCE MANAGE ADMIN-LA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INSURANCE MANAGEMENT ADMINISTRATORS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_157'

;
-- 'Rule 158 - Clone Insurance Management Services'

insert into clone_lead
select *, 'RULE_158' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INSURANCE MGMT SERVICES'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'INSURANCE MANAGEMENT SERVICES',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_158'

;
-- 'Rule 159 - Clone CVS Island Group Administration'

insert into clone_lead
select * , 'RULE_159' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'ISLAND GROUP ADMIN'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ISLAND GROUP ADMINISTRATION',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_159'

;
-- 'Rule 160 - Clone CVS MMM Healthcare'

insert into clone_lead
select *,'RULE_160' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'MMM MEDD%'
or group_name like 'MMM MEDICARE%'
or group_name like 'MMM WRAP%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'MMM HEALTHCARE',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_160'

;
-- 'Rule 161 - Clone CVS Ohana Health'

insert into clone_lead
select *, 'RULE_161' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'WC OHANA MAPD%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'OHANA HEALTH PLAN - WELLCARE',
member_id = left(member_id,8),
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_161'

;
-- 'Rule 162 - Clone CVS Physicians Health Plan (MI)'

insert into clone_lead
select *,'RULE_162' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name = 'PHYSICIANS HEALTH PLAN'
or group_name like 'PHP HMO%'
or group_name like 'PHP INS%'
or group_name like 'PHO SERV%')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PHYSICIANS HEALTH PLAN (MI)',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_162'

;
-- 'Rule 163 - Clone Express Scripts ANIC'

insert into clone_lead
select *, 'RULE_163' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ANIC'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AMERICAN NATIONAL INSURANCE COMPANY',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_163'

;
-- 'Rule 164 - Clone Express Scripts Baptist Health'

insert into clone_lead
select *, 'RULE_164' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'K9RA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BAPTIST HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_164'

;
-- 'Rule 165 - Clone Express Scripts Community Health Options'

insert into clone_lead
select *, 'RULE_165' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'COMMHOP'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'COMMUNITY HEALTH OPTIONS',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_165'

;
-- 'Rule 166 - Clone Express Scripts ConnetiCare'

insert into clone_lead
select *, 'RULE_166' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('CN3A','KZPA','NKYA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CONNECTICARE',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_166'

;
-- 'Rule 167 - Clone Express Scripts Global Health'

insert into clone_lead
select *,'RULE_167' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'KXPA'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'GLOBALHEALTH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_167'

;
-- 'Rule 168 - Clone Express Scripts Physicians Health of N IN'

insert into clone_lead
select *, 'RULE_168' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PHPNIRX'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PHYSICIANS HEALTH PLAN OF NORTHERN INDIANA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_168'

;
-- 'Rule 169 - Clone Express Scripts Physicians Plus'

insert into clone_lead
select *, 'RULE_169' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PPLUSIC'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'PHYSICIANS PLUS INSURANCE CORPORATION',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_169'

;
-- 'Rule 170 - Clone MedImpact Chinese Community'

insert into clone_lead
select *, 'RULE_170' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like '%CHINESE COMMUNITY HEALTH PLAN%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'CHINESE COMMUNITY HEALTH PLAN',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_170'

;
-- 'Rule 171 - Clone MedImpact WEA Trust'

insert into clone_lead
select *, 'RULE_171' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like '%WEA TRUST%'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'WEA TRUST',
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_171'

;
-- 'Rule 172 - Clone Prominence MedImpact'

insert into clone_lead
select *, 'RULE_172' from cob_lead_staging
where carrier_name = 'PROMINENCE HEALTH PLAN'
and group_desc like '%RX%'

;
update clone_lead
set
pbm_bin  = '003585',
pbm_pcn  = 'ASPROD1',
carrier_name = 'MEDIMPACT',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_172'

;
-- 'Rule New - Clone Benefit and Risk Management Services Catamaran'

insert into clone_lead
select *, 'RULE_173' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTBRMS'

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'BENEFIT AND RISK MANAGEMENT SERVICES (BRMS)',
member_id = left(member_id,9),
group_number = NULL, --Added 2/14/2019 DM3.7_Updates
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_173'

;
-- 'Rule 174 - Clone Express Scripts ANTHEM BC CA'

insert into clone_lead
select *, 'RULE_174' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WXHA', 'WLHA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BC CA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_174'

;
-- 'Rule 175 - Clone Express Scripts ANTHEM BCBS CO'

insert into clone_lead
select *, 'RULE_175' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WXEA', 'WLEA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS CO',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_175'

;
-- 'Rule 176 - Clone Express Scripts ANTHEM BCBS CT'

insert into clone_lead
select *, 'RULE_176' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX7A', 'WL7A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS CT',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_176'

;
-- 'Rule 177 - Clone Express Scripts ANTHEM BCBS GA'

insert into clone_lead
select *, 'RULE_177' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number IN ('WXBA', 'WLBA')
or (subgroup_number = 'KINDHME' and group_name like 'ANTHEM%')) --Added 1/8/2009 DM3.6_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS GA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_177'

;
-- 'Rule 178- Clone Express Scripts ANTHEM BCBS IN'

insert into clone_lead
select *, 'RULE_178' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX2A', 'WL2A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS IN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_178'

;
-- 'Rule 179 - Clone Express Scripts ANTHEM BCBS KY'

insert into clone_lead
select * , 'RULE_179' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX3A', 'WL3A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS KY',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_179'

;
-- 'Rule 180 - Clone Express Scripts ANTHEM BCBS ME'

insert into clone_lead
select *, 'RULE_180' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX8A', 'WL8A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS ME',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_180'

;
-- 'Rule 181 - Clone Express Scripts ANTHEM BCBS MO'

insert into clone_lead
select *, 'RULE_181' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX4A', 'WL4A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS MO',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_181'

;
-- 'Rule 182 - Clone Express Scripts ANTHEM BCBS NH'

insert into clone_lead
select *, 'RULE_182' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX9A', 'WL9A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS NH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_182'

;
-- 'Rule 183 - Clone Express Scripts ANTHEM BCBS NV'

insert into clone_lead
select *, 'RULE_183' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WXFA', 'WLFA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS NV',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_183'

;
-- 'Rule 184 - Clone Express Scripts ANTHEM BCBS OH'

insert into clone_lead
select *, 'RULE_184' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number IN ('WX5A', 'WL5A')
or (subgroup_number = 'KINDRED' and group_name like 'ANTHEM%')) --Added 1/8/2019 DM3.6_Updates

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS OH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_184'

;
-- 'Rule 185 - Clone Express Scripts ANTHEM BCBS VA'

insert into clone_lead
select *, 'RULE_185' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WXAA', 'WLAA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS VA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_185'

;
-- 'Rule 186 - Clone Express Scripts ANTHEM BCBS WI'

insert into clone_lead
select *, 'RULE_186' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WX6A', 'WL6A')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM BCBS WI',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_186'

;
-- 'Rule 187 - Clone Express Scripts ANTHEM EMPIRE BCBS'

insert into clone_lead
select *, 'RULE_187' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('WXDA', 'WLDA')

;
update clone_lead
set
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_187'

;
-- 'Rule 188 - Clone Catamaran Affordable Benefit Administrators'

insert into clone_lead
select *, 'RULE_188' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name IN ('RWTABA')

;
update clone_lead
set
member_id = left(member_id,11),
group_number = subgroup_number,
pbm_bin  = NULL,
pbm_pcn  = NULL,
carrier_name = 'AFFORDABLE BENEFIT ADMINISTRATORS',
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_188'

;
-- 'Rule 189 - Clone CVS_Caremark Yale New Haven Health Systems'

insert into clone_lead
select *, 'RULE_189' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'YALE NEW HAVEN HEALTH SYS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS CT',
member_id = NULL,
group_number = NULL,
group_name = 'YALE NEW HAVEN HEALTH SYSTEMS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_189'

;
-- 'Rule 190 - Clone MedImpact Office of Group Benefits'

insert into clone_lead
select *,'RULE_190' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name like '%STATE OF LOUISIANA-OGB%'

;
update clone_lead
set
carrier_name = 'BCBS LA',
member_id = NULL,
group_number = NULL,
group_name = 'OFFICE OF GROUP BENEFITS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_190'

;
-- 'Rule 191 - Clone Catamaran CDS Group Health'

insert into clone_lead
select * , 'RULE_191' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTCDSGH'

;
update clone_lead
set
carrier_name = 'CDS GROUP HEALTH',
member_id = left(member_id ,11),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_191'

;
-- 'Rule 192 - Clone Delta Dental of Puerto Rico, Inc. Constellation Health'

insert into clone_lead
select *, 'RULE_192' from cob_lead_staging
where carrier_name = 'DELTA DENTAL OF PUERTO RICO, INC.'
and group_name = 'CONSTELLATION HEALTH LLC'

;
update clone_lead
set
carrier_name = 'CONSTELLATION HEALTH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_192'

;
-- 'Rule 193 - Clone Catamaran Continental Benefits'

insert into clone_lead
select *, 'RULE_193' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTWELLSY'

;
update clone_lead
set
carrier_name = 'CONTINENTAL BENEFITS',
member_id = policy_id_alt,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_193'

;
-- 'Rule 194 - Clone CVS_Caremark Group Benefit Services'

insert into clone_lead
select *, 'RULE_194' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'GROUP BENEFIT SERVICES'

;
update clone_lead
set
carrier_name = 'GROUP BENEFIT SERVICES',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_194'

;
-- 'Rule 195 - Clone Catamaran Healthedge Administrators'

insert into clone_lead
select *, 'RULE_195' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTHEALED'

;
update clone_lead
set
carrier_name = 'HEALTHEDGE ADMINISTRATORS',
member_id = left(member_id,11),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_195'

;
-- 'Rule 196 - Clone Catamaran HealthScope Benefits'

insert into clone_lead
select *, 'RULE_196' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTHEALTH'

;
update clone_lead
set
carrier_name = 'HEALTHSCOPE BENEFITS',
member_id = policy_id_alt,
group_number = Right(group_number,4),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_196'

;
-- 'Rule 197 - Clone Delta Dental Insurance Company Kaiser Foundation Health Plan'

insert into clone_lead
select *, 'RULE_197' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and (group_name like 'KAISER FOUNDATION HEALTH%'
or group_name in ('KAISER FOUNDATION INDIVIDUAL','KHP')) --Added 2/26/2019 DM4.2_Week5_Updates

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case when plan_type::text like '%DE%' then '{MM}'
when plan_type::text like '%DH%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_197'

;
-- 'Rule 198 - Clone Delta Dental Insurance Company Kaiser Foundation Health Plan'

insert into clone_lead
select * , 'RULE_198' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'KAISER FOUNDATION S%'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = substring(member_id,5,8),
group_number = NULL,
group_name=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = '{MM}'
where match_carrier_rule_id_extra = 'RULE_198'

;
-- 'Rule 199 - Clone Delta Dental Insurance Company Kaiser Foundation Health Plan'

insert into clone_lead
select *, 'RULE_199' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'KPIC %'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = Right(member_id,8),
group_number = NULL,
group_name=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = '{MM}'
where match_carrier_rule_id_extra = 'RULE_199'

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
member_id = case
when member_id Like '000%' then Right(member_id,7)
when member_id Like '00%' and member_id not like '000%' then Right(member_id,8)
else NULL end,
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
-- 'Rule 201 - Clone Delta Dental Insurance Company Kaiser Foundation Health Plan'

insert into clone_lead
select *,'RULE_201' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name like 'KAISER PERMANENTE SR%'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = Right(member_id,7),
group_number = NULL,
group_name=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_201'

;
-- 'Rule 202 - Clone Catamaran Kaiser Foundation Health Plan of the Northwest'

insert into clone_lead
select *, 'RULE_202' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'GH COMMERCIAL'  --Removed Group Health ACA Plan 2/26/2019 DM4.2_Week6_Updates

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
-- 'Rule 203 - Clone MedImpact Seaside Health Plan'

insert into clone_lead
select *, 'RULE_203' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name = 'SEASIDE HEALTH PLAN'

;
update clone_lead
set
carrier_name = 'SEASIDE HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_203'

;
-- 'Rule 204 - Clone CVS_Caremark UMWA Health and Retirement Funds'

insert into clone_lead
select *, 'RULE_204' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'UMWA%'

;
update clone_lead
set
carrier_name = 'UMWA HEALTH AND RETIREMENT FUNDS',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_204'

;
-- 'Rule 205 - Clone Delta Dental of Pennsylvania Vibra Health Plan'

insert into clone_lead
select *, 'RULE_205' from cob_lead_staging
where carrier_name = 'DELTA DENTAL OF PENNSYLVANIA'
and group_name = 'VIBRA HEALTH PLAN, INC.'

;
update clone_lead
set
carrier_name = 'VIBRA HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = '{MC}'
where match_carrier_rule_id_extra = 'RULE_205'

;
-- 'Rule 206 - Clone MedImpact VNSNY Choice'

insert into clone_lead
select *, 'RULE_206' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_number = 'VNS01'

;
update clone_lead
set
carrier_name = 'VNSNY CHOICE',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_206'

;
-- 'Rule 207 - Clone Express_Scripts Arise Health Plan'

insert into clone_lead
select * , 'RULE_207' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('ARISEHX', 'PRVA')
and group_name like 'ARISE%'

;
update clone_lead
set
carrier_name = 'ARISE HEALTH PLAN',
group_number = Substring(group_number, 3,8),
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_207'

;
-- 'Rule 208 - Clone Express_Scripts AspirusArise'

insert into clone_lead
select *, 'RULE_208' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('ARISEHX', 'PRVA')
and group_name like 'ASPIRUS%'

;
update clone_lead
set
carrier_name = 'ASPIRUSARISE',
group_number = Substring(group_number, 3,8),
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_208'

;
-- 'Rule 209 - Clone Express_Scripts BCBS NM (HCSC)'

insert into clone_lead
select *, 'RULE_209' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SONMRXP'
and (group_name like 'BCBS%' or group_name like 'LOVELACE%')

;
update clone_lead
set
carrier_name = 'BCBS NM (HCSC)',
member_id= NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_209'

;
-- 'Rule 210 - Clone Express_Scripts Presbyterian Health Plan'

insert into clone_lead
select *, 'RULE_210' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('SONMRXP','K4NA')
and group_name = 'PRESBYTERIAN'

;
update clone_lead
set
carrier_name = 'PRESBYTERIAN HEALTH PLAN',
member_id= NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_210'

;
-- 'Rule 211 - Clone CVS_Caremark Planned Administrators, Inc. (PAI)'

insert into clone_lead
select *, 'RULE_211' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
--and (group_name IN ('BCBSSC-TCC-RSP','BCBSSC PAI ESS CARE')  --Requested Added BCBSSC-TCC-RSP DM3.6_Updates, but both removed DM3.7_Updates.  Current Document shows removed.  Removed 2/14/2019
and group_name like 'BCBSSC-PAI%' --Changed to wildcard at end 2/14/2019 DM3.6_Updates

;
update clone_lead
set
carrier_name = 'PLANNED ADMINISTRATORS, INC. (PAI)',
member_id= NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_211'

;
-- 'Rule 212 - Clone Express_Scripts Health First Health Plan'

insert into clone_lead
select *, 'RULE_212' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HLTHFST'

;
update clone_lead
set
carrier_name = 'HEALTH FIRST HEALTH PLAN',
member_id=NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_212'

;
-- 'Rule 213 - Clone Express_Scripts Health First Health Plan'

insert into clone_lead
select *, 'RULE_213' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HFHMAPD'

;
update clone_lead
set
carrier_name = 'HEALTH FIRST HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
when plan_type::text like '%PM%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_213'

;
-- 'Rule 214 - Clone CVS_Caremark AliCare'

insert into clone_lead
select *, 'RULE_214' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name='AMALGAMATED HEALTH FUND'

;
update clone_lead
set
carrier_name = 'ALICARE',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_214'

;
-- 'Rule 215 - Clone CVS_Caremark American Plan Administrators'

insert into clone_lead
select *, 'RULE_215' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name='AMERICAN PLAN ADMIN'

;
update clone_lead
set
carrier_name = 'AMERICAN PLAN ADMINISTRATORS',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_215'

;
-- 'Rule 216 - Clone Express_Scripts ANTHEM BCBS CA'

insert into clone_lead
select *, 'RULE_216' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PEPSIRX'
and group_name NOT IN ('RX DISC PROGRAM PEPSICO','TROPICANA, INC.')

;
update clone_lead
set
carrier_name = 'ANTHEM BC CA',  --CHANGED FROM ANTHEM BCBS CA TO ANTHEM BC CA 2/26/2019 DM4.2_WEEK5_UPDATES
member_id = NULL,
group_number = NULL,
group_name= 'PEPSICO',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_216'

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
group_number = Right(subgroup_number,4), --Changed from Right(group_number,4) to Right(Subgroup_number,4) 2/14/2019 DM3.7_Updates
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_217'

;
-- 'Rule 218 - Clone Express_Scripts BCBS MN'

insert into clone_lead
select *, 'RULE_218' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HRTLAND'

;
update clone_lead
set
carrier_name = 'BCBS MN',
member_id = NULL,
group_number = NULL,
group_name= 'HEARTLAND HEALTHCARE FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_218'

;
-- 'Rule 219 - Clone CVS_Caremark BCBS NC'

insert into clone_lead
select *, 'RULE_219' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name='NCSHP1'

;
update clone_lead
set
carrier_name = 'BCBS NC',
member_id = ('YPY'|| member_id),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_219'

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
member_id = ('ZCL' || left(policy_id,9)),
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
-- 'Rule 221 - Clone CVS_Caremark BCBS VT'

insert into clone_lead
select *, 'RULE_221' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'BCBSVT%'

;
update clone_lead
set
carrier_name = 'BCBS VT',
member_id = 'EVT' || policy_ssn,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_221'

;
-- 'Rule 222 - Clone Express_Scripts Carpenters Health & Welfare Trust (St. Louis)'

insert into clone_lead
select *, 'RULE_222' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'STLCARP'

;
update clone_lead
set
carrier_name = 'CARPENTERS HEALTH & WELFARE TRUST (ST. LOUIS)',
member_id = policy_ssn,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_222'

;
-- 'Rule 223 - Clone CVS_Caremark Entrust'

insert into clone_lead
select *, 'RULE_223' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like '%ENTRUST%'

;
update clone_lead
set
carrier_name = 'ENTRUST',
member_id = left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_223'

;
-- 'Rule 224 - Clone CVS_Caremark HealthScope Benefits'

insert into clone_lead
select *, 'RULE_224' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'HEALTH SCOPE%'

;
update clone_lead
set
carrier_name = 'HEALTHSCOPE BENEFITS',
member_id = left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_224'

;
-- 'Rule 225 - Clone CVS_Caremark Johns Hopkins EHP '

insert into clone_lead
select *, 'RULE_225' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'EMP HP-JOHNS HOPKINS'

;
update clone_lead
set
carrier_name = 'JOHNS HOPKINS EHP',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_225'

;
-- 'Rule 226 - Clone CVS_Caremark Johns Hopkins Advantage MD'

insert into clone_lead
select *, 'RULE_226' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'JOHNS HOPKINS MAPD%'
or group_name like 'JOHNS HOPKINS EGWP%')

;
update clone_lead
set
carrier_name = 'JOHNS HOPKINS ADVANTAGE MD',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_226'

;
-- 'Rule 227 - Clone Catamaran Medcost Benefit Services'

insert into clone_lead
select * , 'RULE_227' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name IN ('CTRNC3110','MBS')

;
update clone_lead
set
carrier_name = 'MEDCOST BENEFIT SERVICES',
group_number = member_id_alt,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_227'

;
-- 'Rule 228 - Clone CVS_Caremark NCAS'

insert into clone_lead
select *, 'RULE_228' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'CF-(NCAS)%'
or group_name like 'NCAS%'
or group_name like 'CF-NCAS%')

;
update clone_lead
set
carrier_name = 'NCAS',
member_id=NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_228'

;
-- 'Rule 229 - Clone CVS_Caremark Optimed Health Plans'

insert into clone_lead
select *, 'RULE_229' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'OPTIMED HEALTH PLANS'

;
update clone_lead
set
carrier_name = 'OPTIMED HEALTH PLANS',
member_id=NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_229'

;
-- 'Rule 230 - Clone Catamaran Preferred Benefit Administrators'

insert into clone_lead
select *,'RULE_230' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name='RWTPREF'

;
update clone_lead
set
carrier_name = 'PREFERRED BENEFIT ADMINISTRATORS',
member_id = left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_230'

;
-- 'Rule 231 - Clone Express_Scripts UHA Health Insurance'

insert into clone_lead
select *, 'RULE_231' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NKTA'

;
update clone_lead
set
carrier_name = 'UHA HEALTH INSURANCE',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_231'

;
-- 'Rule 232 - Clone Express_Scripts Wisconsin Collaborative Insurance Company '

insert into clone_lead
select *, 'RULE_232' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WLWA'

;
update clone_lead
set
carrier_name = 'WISCONSIN COLLABORATIVE INSURANCE COMPANY',
member_id = ('ZEZ'|| policy_ssn),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_232'

;
-- 'Rule 233 - Clone Express_Scripts HealthSmart '

insert into clone_lead
select * , 'RULE_233' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('AGNHSRX', 'CLXHSRX', 'HSBHSRX', 'HSCHSRX', 'HSPHSRX', 'JKNHSRX', 'KLAHSRX', 'MAAHSRX', 'MBNHSRX', 'MRTHSRX', 'NAAHSRX', 'PBAHSRX', 'TCTHSRX', 'TPNHSRX','WLSHSRX')
and coalesce(group_number,'') not in ('8040AGNONIBM001', '8040AGNONINM001') --Added 10/22/2019 per DM4.7_Week29_Updates TPLA-658

;
update clone_lead
set
carrier_name = 'HEALTHSMART',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_233'

;
-- 'Rule 234 - Clone Catamaran HealthSmart'

insert into clone_lead
select *, 'RULE_234' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name='RWTMAA'

;
update clone_lead
set
carrier_name = 'HEALTHSMART',
member_id = left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_234'

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
member_id = case
when left(member_id,1) = 'K' then Left(member_id,11)
else NULL end,
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
--     member_id = case
--         when left(member_id,3) = 'HPU' then Left(member_id,12)
--when left(member_id,2) = 'HE' then 'HPU00' || Substring(member_id,3,7)
--         else member_id end,
member_id = case
when policy_id_alt like 'HE%' then 'HPU00' || Right(policy_id_alt,length(policy_id_alt)-2)  --Updated member_id 2/14/2019 DM3.6_Updates
else policy_id_alt end,
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_236'

;
-- 'Rule 237 - Clone CVS_Caremark Ambetter AR (Arkansas Health & Wellness)'

insert into clone_lead
select * , 'RULE_237' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM AR%'

;
update clone_lead
set
carrier_name = 'AMBETTER AR (ARKANSAS HEALTH & WELLNESS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_237'

;
-- 'Rule 238 - Clone CVS_Caremark Ambetter AZ (Health Net)'

insert into clone_lead
select *, 'RULE_238' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM AZ%'

;
update clone_lead
set
carrier_name = 'AMBETTER AZ (HEALTH NET)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_238'

;
-- 'Rule 239 - Clone CVS_Caremark Ambetter CA (Health Net)'

insert into clone_lead
select *, 'RULE_239' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM CA%'

;
update clone_lead
set
carrier_name = 'AMBETTER CA (HEALTH NET)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_239'

;
-- 'Rule 240 - Clone CVS_Caremark Ambetter FL (Sunshine Health)'

insert into clone_lead
select * , 'RULE_240' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM FL%'

;
update clone_lead
set
carrier_name = 'AMBETTER FL (SUNSHINE HEALTH)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_240'

;
-- 'Rule 241 - Clone CVS_Caremark Ambetter GA (Peach State Health Plan)'

insert into clone_lead
select *, 'RULE_241' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM GA%'

;
update clone_lead
set
carrier_name = 'AMBETTER GA (PEACH STATE HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_241'

;
-- 'Rule 242 - Clone CVS_Caremark Ambetter IL (Illinicare)'

insert into clone_lead
select * , 'RULE_242' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM IL%'

;
update clone_lead
set
carrier_name = 'AMBETTER IL (ILLINICARE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_242'

;
-- 'Rule 243 - Clone CVS_Caremark Ambetter IN (MHS)'

insert into clone_lead
select * , 'RULE_243' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM IN%'

;
update clone_lead
set
carrier_name = 'AMBETTER IN (MHS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_243'

;
-- 'Rule 244 - Clone CVS_Caremark Ambetter KS (Sunflower Health Plan)'

insert into clone_lead
select *,'RULE_244' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM KS%'

;
update clone_lead
set
carrier_name = 'AMBETTER KS (SUNFLOWER HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_244'

;
-- 'Rule 245 - Clone CVS_Caremark Ambetter MA (Celticare Health Plan)'

insert into clone_lead
select *, 'RULE_245' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM MA%'

;
update clone_lead
set
carrier_name = 'AMBETTER MA (CELTICARE HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_245'

;
-- 'Rule 246 - Clone CVS_Caremark Ambetter MS (Magnolia Health)'

insert into clone_lead
select * , 'RULE_246' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM MS%'

;
update clone_lead
set
carrier_name = 'AMBETTER MS (MAGNOLIA HEALTH)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_246'

;
-- 'Rule 247 - Clone CVS_Caremark Ambetter MO (Home State Health)'

insert into clone_lead
select * , 'RULE_247' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM MO%'

;
update clone_lead
set
carrier_name = 'AMBETTER MO (HOME STATE HEALTH)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_247'

;
-- 'Rule 248 - Clone CVS_Caremark Ambetter NV (SilverSummit Healthplan)'

insert into clone_lead
select *, 'RULE_248' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM NV%'

;
update clone_lead
set
carrier_name = 'AMBETTER NV (SILVERSUMMIT HEALTHPLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_248'

;
-- 'Rule 249 - Clone CVS_Caremark Ambetter NH (NH Healthy Families)'

insert into clone_lead
select *, 'RULE_249' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM NH%'

;
update clone_lead
set
carrier_name = 'AMBETTER NH (NH HEALTHY FAMILIES)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_249'

;
-- 'Rule 250 - Clone CVS_Caremark Ambetter OH (Buckeye Health Plan)'

insert into clone_lead
select *, 'RULE_250' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM OH%'

;
update clone_lead
set
carrier_name = 'AMBETTER OH (BUCKEYE HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_250'

;
-- 'Rule 251 - Clone CVS_Caremark Ambetter TX (Superior HealthPlan)'

insert into clone_lead
select *, 'RULE_251' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM TX%'

;
update clone_lead
set
carrier_name = 'AMBETTER TX (SUPERIOR HEALTHPLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_251'

;
-- 'Rule 252 - Clone CVS_Caremark Ambetter WA (Coordinated Care)'

insert into clone_lead
select *, 'RULE_252' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like '%HIM WA%'

;
update clone_lead
set
carrier_name = 'AMBETTER WA (COORDINATED CARE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_252'

;
-- 'Rule 253 - Clone CVS_Caremark Allwell AR (Arkansas Health & Wellness)'

insert into clone_lead
select *, 'RULE_253' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC AR MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL AR (ARKANSAS HEALTH & WELLNESS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_253'

;
-- 'Rule 254 - Clone CVS_Caremark Allwell AZ (Health Net)'

insert into clone_lead
select *, 'RULE_254' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC AZ MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL AZ (HEALTH NET)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_254'

;
-- 'Rule 255 - Clone CVS_Caremark Allwell CA (Health Net)'

insert into clone_lead
select *, 'RULE_255' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC CA MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL CA (HEALTH NET)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_255'

;
-- 'Rule 256 - Clone CVS_Caremark Allwell FL (Sunshine State)'

insert into clone_lead
select * , 'RULE_256' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC FL MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL FL (SUNSHINE STATE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_256'

;
-- 'Rule 257 - Clone CVS_Caremark Allwell GA (Peach State Health Plan)'

insert into clone_lead
select *, 'RULE_257' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC GA MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL GA (PEACH STATE HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_257'

;
-- 'Rule 258 - Clone CVS_Caremark Allwell IN (MHS)'

insert into clone_lead
select *, 'RULE_258' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC IN MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL IN (MHS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_258'

;
-- 'Rule 259 - Clone CVS_Caremark Allwell KS (Sunflower Health Plan)'

insert into clone_lead
select *, 'RULE_259' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC KS MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL KS (SUNFLOWER HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_259'

;
-- 'Rule 260 - Clone CVS_Caremark Allwell LA (Louisiana Healthcare Connections)'

insert into clone_lead
select *, 'RULE_260' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC LA MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL LA (LOUISIANA HEALTHCARE CONNECTIONS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_260'

;
-- 'Rule 261 - Clone CVS_Caremark Allwell MO (Home State Health)'

insert into clone_lead
select *, 'RULE_261' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC MO MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL MO (HOME STATE HEALTH)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_261'

;
-- 'Rule 262 - Clone CVS_Caremark Allwell MS (Magnolia Health)'

insert into clone_lead
select *, 'RULE_262' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC MS MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL MS (MAGNOLIA HEALTH)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_262'

;
-- 'Rule 263 - Clone CVS_Caremark Allwell OH (Buckeye Health Plan)'

insert into clone_lead
select *, 'RULE_263' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC OH MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL OH (BUCKEYE HEALTH PLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_263'

;
-- 'Rule 264 - Clone CVS_Caremark Allwell OR (Trillium Medicare Advantage)'

insert into clone_lead
select * , 'RULE_264' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC OR MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL OR (TRILLIUM MEDICARE ADVANTAGE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_264'

;
-- 'Rule 265 - Clone CVS_Caremark Allwell PA (PA Health & Wellness)'

insert into clone_lead
select *, 'RULE_265' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC PA MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL PA (PA HEALTH & WELLNESS)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_265'

;
-- 'Rule 266 - Clone CVS_Caremark Allwell SC (Absolute Total Care)'

insert into clone_lead
select *, 'RULE_266' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC SC MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL SC (ABSOLUTE TOTAL CARE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_266'

;
-- 'Rule 267 - Clone CVS_Caremark Allwell TX (Superior HealthPlan)'

insert into clone_lead
select *, 'RULE_267' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC TX MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL TX (SUPERIOR HEALTHPLAN)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_267'

;
-- 'Rule 268 - Clone CVS_Caremark Allwell WA (Coordinated Care)'

insert into clone_lead
select *, 'RULE_268' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC WA MAPD%'

;
update clone_lead
set
carrier_name = 'ALLWELL WA (COORDINATED CARE)',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_268'

;
-- 'Rule 269 - Clone Express_Scripts EMBLEM HEALTH'

insert into clone_lead
select * , 'RULE_269' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'UFTWFRX'
and coalesce(group_name,'') <> 'PRESCRIPTION ONLY'
and pbm_person_code='01';

update clone_lead
set
carrier_name = 'EMBLEM HEALTH',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_269';

-- 'Rule 270 - Clone Express_Scripts Aetna'

insert into clone_lead
select *, 'RULE_270' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'MEDMRCK'
and group_number like '%A'

;
update clone_lead
set
carrier_name = 'AETNA',
member_id = NULL,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_270'

;
-- 'Rule 271 - Clone Catamaran Allegiance Benefit Plan Management '

insert into clone_lead
select * , 'RULE_271' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'ALLEGIANCE%' --Changed from ALLEGIANCE BENEFIT PLAN to ALLEGIANCE% 2/14/2019 DM3.7_Updates

;
update clone_lead
set
carrier_name = 'ALLEGIANCE BENEFIT PLAN MANAGEMENT',
member_id =left(member_id,12),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_271'

;
-- 'Rule 272 - Clone Catamaran Americas Choice Healthplans '

insert into clone_lead
select *,'RULE_272' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'AMERICA''S CHOICE HLTHPLN'

;
update clone_lead
set
carrier_name = 'AMERICA''S CHOICE HEALTHPLANS',
member_id =left(member_id,10),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_271'

;
-- 'Rule 273 - Clone CVS_Caremark Automated Group Administration'

insert into clone_lead
select *, 'RULE_273' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'AUTOMATED GROUP ADMIN'

;
update clone_lead
set
carrier_name = 'AUTOMATED GROUP ADMINISTRATION',
member_id =left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_273'

;
-- 'Rule 274 - Clone MedImpact BCBS AZ'

insert into clone_lead
select *, 'RULE_274' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_number = 'BHP01'

;
update clone_lead
set
carrier_name = 'BCBS AZ',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_274'

;
-- 'Rule 275 - Clone MedImpact BCBS KS CY '

insert into clone_lead
select *, 'RULE_275' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name = 'H1352'

;
update clone_lead
set
carrier_name = 'BCBS KS CY',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_275'

;
-- 'Rule 276 - Clone Express_Scripts BCBS NJ'

insert into clone_lead
select *, 'RULE_276' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('286HWRX','MEDMRCK')
and group_number like '%H'

;
update clone_lead
set
carrier_name = 'BCBS NJ',
member_id = ('NAT'|| policy_ssn),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_276'

;
-- 'Rule 277 - Clone Catamaran Benefit Management Administrators'

insert into clone_lead
select *, 'RULE_277' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTBMA'

;
update clone_lead
set
carrier_name = 'BENEFIT MANAGEMENT ADMINISTRATORS',
member_id =left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_277'

;
-- 'Rule 278 - Clone Catamaran Benefit Management LLC'

insert into clone_lead
select * , 'RULE_278' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTBENMNT'

;
update clone_lead
set
carrier_name = 'BENEFIT MANAGEMENT LLC',
member_id =left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_278'

;
-- 'Rule 279 - Clone Catamaran Benefit Management Inc'

insert into clone_lead
select *, 'RULE_279' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'HTRBMI'

;
update clone_lead
set
carrier_name = 'BENEFIT MANAGEMENT INC',
member_id =left(member_id,11),
group_number=NULL,
group_name=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_279'

;
-- 'Rule 280 - Clone CVS_Caremark Benefit Management Inc'

insert into clone_lead
select *, 'RULE_280' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name ='BENEFIT MANAGEMENT-MO'


;
update clone_lead
set
carrier_name = 'BENEFIT MANAGEMENT INC',
member_id =left(member_id,11),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_280'
;
-- 'Rule 281 - Clone Catamaran Benefit Plan Services'

insert into clone_lead
select *, 'RULE_281' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name= 'CTRNC3032'

;
update clone_lead
set
carrier_name = 'BENEFIT PLAN SERVICES',
member_id =left(member_id,9),
group_number=NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_281'

;
-- 'Rule 282 - Clone CVS_Caremark Boon-Chapman'

insert into clone_lead
select *, 'RULE_282' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BOON CHAPMAN'

;
update clone_lead
set
carrier_name = 'BOON-CHAPMAN',
member_id =left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_282'

;
-- 'Rule 283 - Clone CVS_Caremark Boon Group'

insert into clone_lead
select *, 'RULE_283' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BOON ADMINISTRATIVE SRVS'

;
update clone_lead
set
carrier_name = 'THE BOON GROUP',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_283'

;
-- 'Rule 284 - Clone Express_Scripts Capital Blue Cross'

insert into clone_lead
select *, 'RULE_284' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PATRUST'
and coalesce(group_name,'') <> 'PLEASANT VLY SCHOOL DIST'

;
update clone_lead
set
carrier_name = 'CAPITAL BLUE CROSS',
member_id = ('BYS'|| member_id),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_284'

;
-- 'Rule 285 - Clone Delta Dental Insurance Company Central Health Medicare Plan '

insert into clone_lead
select *, 'RULE_285' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name = 'CENTRAL HEALTH MEDICARE PLAN'

;
update clone_lead
set
carrier_name = 'CENTRAL HEALTH MEDICARE PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%DE%' then '{MC}'
when plan_type::text like '%DH%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_285'

;
-- 'Rule 286 - Clone Catamaran Coastal Administrative Services'

insert into clone_lead
select *, 'RULE_286' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name= 'RWTCAS'

;
update clone_lead
set
carrier_name = 'COASTAL ADMINISTRATIVE SERVICES',
member_id =left(member_id,9),
group_number= left(group_number,8),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_286'

;
-- 'Rule 287 - Clone MedImpact Community Care Health Plan '

insert into clone_lead
select *, 'RULE_287' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name = 'COMMUNITY CARE HEALTH'

;
update clone_lead
set
carrier_name = 'COMMUNITY CARE HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_287'

;
-- 'Rule 288- Clone Express_Scripts Community Health Plan of Washington'

insert into clone_lead
select *, 'RULE_288' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CHWA'
and group_name NOT IN ('COMMUNITY HEALTH PLAN OF')

;
update clone_lead
set
carrier_name = 'COMMUNITY HEALTH PLAN OF WASHINGTON',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_288'

;
-- 'Rule 289 - Clone Express_Scripts Coventry Health Care '

insert into clone_lead
select *, 'RULE_289' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN('CVTY116', 'CVTY0916', 'CVTY0117', 'CVTY0117II',
'CVTY1216', 'CVTYCOO', 'CVTY1017')

;
update clone_lead
set
carrier_name = 'COVENTRY HEALTH CARE',
member_id = (member_id || pbm_person_code),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_289'

;
-- 'Rule 290 - Clone Catamaran Diversified Group'

insert into clone_lead
select *, 'RULE_290' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'DIVERSIFIED GROUP'

;
update clone_lead
set
carrier_name = 'DIVERSIFIED GROUP',
member_id =left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_290'

;
-- 'Rule 291 - Clone CVS_Caremark EBSO'

insert into clone_lead
select *, 'RULE_291' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'EBSO'

;
update clone_lead
set
carrier_name = 'EBSO',
member_id =left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_291'

;
-- 'Rule 292 - Clone Express_Scripts EMI Health'

insert into clone_lead
select *, 'RULE_292' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number IN ('AS802RX', 'EMIARXD', 'EMIASP1', 'EMIAPDP')
and member_id like '274%'

;
update clone_lead
set
carrier_name = 'EMI HEALTH',
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_292'

;
-- 'Rule 293 - Clone Express_Scripts Geisinger Health Plan '

insert into clone_lead
select *, 'RULE_293' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'GEISINGER HEALTH PLAN'

;
update clone_lead
set
carrier_name = 'GEISINGER HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_293'

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
-- 'Rule 295 - Clone CVS_Caremark Gilsbar'

insert into clone_lead
select *, 'RULE_295' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name= 'PEOPLES HEALTH COMM'

;
update clone_lead
set
carrier_name = 'GILSBAR',
group_number = 'S2790',
group_name= 'PEOPLES HEALTH',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_295'

;
-- 'Rule 296 - Clone Catamaran Group Administrators'

insert into clone_lead
select *, 'RULE_296' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name= 'RWTGPA'

;
update clone_lead
set
carrier_name = 'GROUP ADMINISTRATORS',
member_id =left(member_id,9),
group_name = NULL,
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_296'

;
-- 'Rule 297 - Clone Express_Scripts Group & Pension Administrators (GPA)'

insert into clone_lead
select *, 'RULE_297' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'GPARX4U'

;
update clone_lead
set
carrier_name = 'GROUP & PENSION ADMINISTRATORS (GPA)',
member_id = NULL,
group_number = left(group_number,7),
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_297'

;
-- 'Rule 298 - Clone Catamaran Health Net'

insert into clone_lead
select *, 'RULE_298' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'CALPERS-HEALTHNET'

;
update clone_lead
set
carrier_name = 'HEALTH NET',
member_id =left(member_id,9),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_298'

;
-- 'Rule 299 - Clone CVS_Caremark Health Plans, Inc.'

insert into clone_lead
select *, 'RULE_299' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'HEALTH PLANS%'

;
update clone_lead
set
carrier_name = 'HEALTH PLANS, INC.',
member_id =left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_299'
;
-- 'Rule 300 - Clone Express_Scripts HealthNow Administrative Services'

insert into clone_lead
select *, 'RULE_300' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HNASTPA'

;
update clone_lead
set
carrier_name = 'HEALTHNOW ADMINISTRATIVE SERVICES',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_300'

;
-- 'Rule 301 - Clone Express_Scripts Highmark Blue Cross'

insert into clone_lead
select *, 'RULE_301' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'PLEASANT VLY SCHOOL DIST'

;
update clone_lead
set
carrier_name = 'HIGHMARK BLUE CROSS',
member_id = ('YYP'|| member_id),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_301'
;
-- 'Rule 302 - Clone Express_Scripts Johns Hopkins EHP'

insert into clone_lead
select *, 'RULE_302' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'JOHNSHOPKINSRX'
and group_name='JHU EHP ACTIVES'

;
update clone_lead
set
carrier_name = 'JOHNS HOPKINS EHP',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_302'
;
-- 'Rule 303 - Clone CVS_Caremark Aetna'

insert into clone_lead
select *, 'RULE_303' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'KSE - COVENTRY CDH'

;
update clone_lead
set
carrier_name = 'AETNA',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_303'
;
-- 'Rule 304 - Clone CVS_Caremark BCBS KS'

insert into clone_lead
select *, 'RULE_304' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'KSE - BCBS CDH'

;
update clone_lead
set
carrier_name = 'BCBS KS',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_304'
;
-- 'Rule 305 - Clone Catamaran Mayo Management Services'

insert into clone_lead
select *, 'RULE_305' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name IN ('MCLMAYO','MCLMMSI')

;
update clone_lead
set
carrier_name = 'MEDICA HEALTH PLANS', --CHANGED FROM 'MAYO MANAGEMENT SERVICES' TO 'MEDICA HEALTH PLANS' 10/22/2019 PER DM4.7_WEEK27_UPDATES TPLA-581
member_id = left(member_id,10), --Added 10/22/2019 per DM4.7_Week27_Updates TPLA-581
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_305'
;
-- 'Rule 306 - Clone Catamaran Medical Mutual'

insert into clone_lead
select *, 'RULE_306' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'MEDICAL MUTUAL'

;
update clone_lead
set
carrier_name = 'MEDICAL MUTUAL',
member_id = NULL,
group_number = '228000201',
group_name = 'STATE OF OHIO',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_306'
;
-- 'Rule 307 - Clone CVS_Caremark MediGold'

insert into clone_lead
select *, 'RULE_307' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MOUNT CARMEL HP MAPD'

;
update clone_lead
set
carrier_name = 'MEDIGOLD',
member_id =left(member_id,9),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_307'
;
-- 'Rule 308 - Clone Catamaran Meritain'

insert into clone_lead
select *, 'RULE_308' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTCBSA'

;
update clone_lead
set
carrier_name = 'MERITAIN',
member_id =left(member_id,10),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_308'
;
-- 'Rule 309 - Clone CVS_Caremark Network Health'

insert into clone_lead
select *, 'RULE_309' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name IN ('NHP-COMMERCIAL', 'NHP-HSA', 'NHP-INDIV FAMILY PLAN', 'NHP-SELF FUNDED', 'NHP-WAG HSA', 'NHP-WAG COMMERCIAL', 'NHP-WAG SELF FUNDED', 'NHP-WAG INDIV FAMILY PLAN', 'NHP ASSURE ELITE', 'NHP-IFP HSA')

;
update clone_lead
set
carrier_name = 'NETWORK HEALTH',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_309'
;
-- 'Rule 310 - Clone Express_Scripts Network Health'

insert into clone_lead
select *, 'RULE_310' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'NETWORK HEALTH PLAN' --Changed from subgroup_number = 'NETWORK HEALTH PLAN' to group_name = 'NETWORK HEALTH PLAN' 10/22/2019 per DM4.8_Week31_Updates TPLA-777

;
update clone_lead
set
carrier_name = 'NETWORK HEALTH',
member_id = NULL,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%PM%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_310'
;
-- 'Rule 311 - Clone Express_Scripts Northwest Administrators'

insert into clone_lead
select *, 'RULE_311' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WWT1000'

;
update clone_lead
set
carrier_name = 'NORTHWEST ADMINISTRATORS',
member_id = policy_ssn,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_311'
;
-- 'Rule 312 - Clone CVS_Caremark PreferredOne'

insert into clone_lead
select *, 'RULE_312' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'PEIP PREFONE'

;
update clone_lead
set
carrier_name = 'PREFERREDONE',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_312'
;
-- 'Rule 313 - Clone United Healthcare Highmark BCBS'

insert into clone_lead
select *, 'RULE_313' from cob_lead_staging
where carrier_name = 'UNITED HEALTHCARE'
and subgroup_number = 'RAILROAD HIGHMARK'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL
where match_carrier_rule_id_extra = 'RULE_313'
;
-- 'Rule 314 - Clone MedImpact Security Health Plan'

insert into clone_lead
select *, 'RULE_314' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name IN ('SECURITY HEALTH PLAN','H5211')

;
update clone_lead
set
carrier_name = 'SECURITY HEALTH PLAN',
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_314'
;
-- 'Rule 315 - Clone Catamaran Sharp Health Plan'

insert into clone_lead
select *, 'RULE_315' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'CALPERS-SHARP'

;
update clone_lead
set
carrier_name = 'SHARP HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_315'
;
-- 'Rule 316 - Clone CVS_Caremark TCC Benefit Administrator'

insert into clone_lead
select *, 'RULE_316' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BCBSSC-TCC-RSP'

;
update clone_lead
set
carrier_name = 'TCC BENEFIT ADMINISTRATOR',
member_id = NULL,
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_316'
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
member_id = 'KJP74'|| Right(policy_id_alt,7),
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
member_id = 'UXI74'|| Right(policy_id_alt,7),
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_318'
;
-- 'Rule 319 - Clone Catamaran Tufts Health Plan'

insert into clone_lead
select *, 'RULE_319' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name='RWTUNITE'
and subgroup_number ='UHH00108'

;
update clone_lead
set
carrier_name = 'TUFTS HEALTH PLAN',
member_id =NULL,
group_number=NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_319'
;
-- 'Rule 320 - Clone Catamaran Western Health Advantage'

insert into clone_lead
select *, 'RULE_320' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'CALPERS WESTERN HLTH ADV'

;
update clone_lead
set
carrier_name = 'WESTERN HEALTH ADVANTAGE',
member_id =left(member_id,9),
group_number=NULL,
group_name ='CALPERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_320'
;
-- 'Rule 321 - Clone Cox HealthPlans'

insert into clone_lead
select *, 'RULE_321' from cob_lead_staging
where carrier_name = 'COX HEALTHPLANS'

;
update clone_lead
set
carrier_name = 'ENVISIONRX',
group_number = 'COXHP',
pbm_bin  = '009893',
pbm_pcn  = 'ROIRX',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_321'
;
-- 'Rule 322 - Clone First Carolina Care Plan Type MM'

insert into clone_lead
select *, 'RULE_322' from cob_lead_staging
where carrier_name = 'FIRSTCAROLINACARE'
and plan_type = '{MM}'

;
update clone_lead
set
carrier_name = 'MEDIMPACT',
group_number = NULL,
pbm_bin  = '003585',
pbm_pcn  = '34400',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_322'
;
-- 'Rule 323 - Clone First Carolina Care Plan Type MC'

insert into clone_lead
select *, 'RULE_323' from cob_lead_staging
where carrier_name = 'FIRSTCAROLINACARE'
and plan_type = '{MC}'

;
update clone_lead
set
carrier_name = 'MEDIMPACT',
group_number = NULL,
pbm_bin  = '015574',
pbm_pcn  = 'ASPROD1',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_323'
;
-- 'Rule 324 - Clone Ultimate Health Plans'

insert into clone_lead
select *, 'RULE_324' from cob_lead_staging
where carrier_name = 'ULTIMATE HEALTH PLANS'

;
update clone_lead
set
carrier_name = 'ENVISIONRX',
pbm_bin  = '012312',
pbm_pcn  = 'PARTD',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_324'
;
-- 'Rule 325 - Clone CVS_Caremark MACO HEALTH CARE TRUST'

insert into clone_lead
select *, 'RULE_325' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MACO HEALTH CARE TRUST'

;
update clone_lead
set
carrier_name = 'ALLEGIANCE BENEFIT PLAN MANAGEMENT',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_325'
;
-- 'Rule 326 - Clone Catamaran MedName RWTKERN'

insert into clone_lead
select *, 'RULE_326' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTKERN'

;
update clone_lead
set
carrier_name = 'KERN LEGACY HEALTH PLANS',  --CHANGED FROM ANTHEM BC CA TO KERN LEGACY HEALTH PLANS 6/6/2019 DM4.5_WEEK22_UPDATES
member_id = left(member_id,12),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_326'
;
-- 'Rule 327 - Clone CVS_Caremark KOCH INDUSTRIES'

insert into clone_lead
select *, 'RULE_327' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'KOCH INDUSTRIES'

;
update clone_lead
set
carrier_name = 'ANTHEM BC CA',
member_id = left(member_id,9),
group_number = NULL,
group_name = 'KOCH INDUSTRIES INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_327'
;
-- 'Rule 328 - Clone CVS_Caremark NOITU INS TRUST FUND'

insert into clone_lead
select *, 'RULE_328' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'NOITU INS TRUST FUND'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = left(member_id,12),
group_number = NULL,
group_name = 'NOITU',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_328'
;
-- 'Rule 329 - Clone OptumRX'

insert into clone_lead
select *, 'RULE_329' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and policy_employer_name = 'BCBS AL'
and coalesce(group_name,'') <> 'ZZZ'

;
update clone_lead
set
carrier_name = 'BCBS AL',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_329'
;
-- 'Rule 330 - Clone CVS_Caremark BNSF RAILWAY COMPANY'

insert into clone_lead
select *, 'RULE_330' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BNSF RAILWAY COMPANY'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'BNF' || member_ssn,
group_number = NULL,
group_name = 'BNSF RAILWAY COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_330'
;
-- 'Rule 331 - Clone Express_Scripts BNSF RAILWAY COMPANY'

insert into clone_lead
select *, 'RULE_331' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number in ('DSMA', 'RXBVERI', 'NJTCPRX', 'JNAA', 'JQLA') --Added 10/21/2019 per DM4.6_Week24_Updates TPLA-520
or group_name in ('BBB OMNIA 76186', 'COST PLUS OMNIA 76186', 'HRZN-OMNIA GRPS', 'OMNI PLAN', 'OMNIAPLN'))

;
update clone_lead
set
carrier_name = 'BCBS NJ',
member_id = ('NAT'|| policy_ssn),
group_number = NULL,
group_name= NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_331'
;
-- 'Rule 332 - Clone CVS_Caremark BUSINESS ADMIN% or BUS ADMIN%'

insert into clone_lead
select *, 'RULE_332' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'BUSINESS ADMIN%'
or group_name like 'BUS ADMIN%')

;
update clone_lead
set
carrier_name = 'BUSINESS ADMINISTRATORS & CONSULTANTS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_332'
;
-- 'Rule 333 - Clone Catamaran CCOK%'

insert into clone_lead
select *, 'RULE_333' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'CCOK%'

;
update clone_lead
set
carrier_name = 'COMMUNITYCARE OF OKLAHOMA',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_333'
;
-- 'Rule 334 - Clone Catamaran MedName GCHP'

insert into clone_lead
select *, 'RULE_334' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'GCHP'

;
update clone_lead
set
carrier_name = 'GOLD COAST HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_334'
;
-- 'Rule 335 - Clone CVS_Caremark GOODYEAR RETIREE HC TRUST'

insert into clone_lead
select *, 'RULE_335' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name in ('GOODYEAR RETIREE HC TRUST','PNC FINANCIAL SERV GROUP')
or group_name like 'ARCONIC%') --Added this line and PNC Financial Serv Group 10/22/2019 per DM4.7_Week27_Updates TPLA-581

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'YYP' || left(member_id,9), --Changed from member_id = 'YYP' || member_ssn to member_id = 'YYP' || Left(member_id,9) 10/22/2019 per DM4.7_Week27_Updates TPLA-581
group_number = NULL,
group_name = NULL, --Changed from group_name = 'GOODYEAR RETIREE VEBA HEALTH CARE PLAN' to group_name = NULL 10/22/2019 per DM4.7_Week27_Updates TPLA-581
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_335'
;
-- 'Rule 336 - Clone CVS_Caremark GOODYEAR RETIREE HC TRUST'

insert into clone_lead
select *, 'RULE_336' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('SSI-GOODYEAR RETIREE HC','GOODYEAR RETIREE HC STCOB')

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'YYP' || member_ssn,
group_number = NULL,
group_name = 'RETIREES OF THE GOODYEAR TIRE & RUBBER COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_336'
;
-- 'Rule 337 - Clone CVS_Caremark MCA ADMINISTRATORS INC'

insert into clone_lead
select *, 'RULE_337' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MCA ADMINISTRATORS INC'

;
update clone_lead
set
carrier_name = 'MCA ADMINISTRATORS (MANAGED CARE OF AMERICA)',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_337'
;
-- 'Rule 338 - Clone CVS_Caremark MEMORIAL HERMANN'

insert into clone_lead
select *, 'RULE_338' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'MEMORIAL HERMANN'

;
update clone_lead
set
carrier_name = 'MEMORIAL HERMANN HEALTH INSURANCE',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_338'
;
-- 'Rule 339 - Clone Catamaran MedName RWTMODA'

insert into clone_lead
select *, 'RULE_339' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTMODA'

;
update clone_lead
set
carrier_name = 'MODA HEALTH',
member_id = left(member_id,9),
group_number = NULL,
group_name = 'MULTNOMAH COUNTY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_339'
;
-- 'Rule 340 - Clone CVS_Caremark MOLINA MEDICARE MAPD%'

insert into clone_lead
select *, 'RULE_340' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'MOLINA MEDICARE MAPD%'

;
update clone_lead
set
carrier_name = 'MOLINA HEALTHCARE',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
when plan_type::text like '%PE%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_340'
;
-- 'Rule 341 - Clone CVS_Caremark PREFERRED BENEFIT ADMIN. ID 3% or 4%'

insert into clone_lead
select *, 'RULE_341' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'PREFERRED BENEFIT ADMIN.'
and (policy_id like '3%'
or policy_id like '4%')

;
update clone_lead
set
carrier_name = 'PREFERRED BENEFIT ADMINISTRATORS',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_341'
;
-- 'Rule 342 - Clone CVS_Caremark PREMIER ASO, PREMIER EMP, PREMIER HIX OFF, PREMIER MED D, PREMIER LG'

insert into clone_lead
select *, 'RULE_342' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('PREMIER ASO', 'PREMIER EMP', 'PREMIER HIX OFF', 'PREMIER MED D', 'PREMIER LG')

;
update clone_lead
set
carrier_name = 'PREMIER HEALTH PLAN',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_342'
;
-- 'Rule 343 - Clone Catamaran MedName RWTPHARM1'

insert into clone_lead
select *, 'RULE_343' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTPHARM1'

;
update clone_lead
set
carrier_name = 'SECUREONE BENEFIT ADMINISTRATORS',
member_id = policy_id_alt,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_343'
;
-- 'Rule 344 - Clone CVS_Caremark TOTAL PLAN SERVICES%'

insert into clone_lead
select *, 'RULE_344' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'TOTAL PLAN SERVICES%'

;
update clone_lead
set
carrier_name = 'TOTAL PLAN SERVICES',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_344'
;
-- 'Rule 345 - Clone Delta Dental Insurance Company of WA, KAISER FOUNDATION or KP I&F Fam-Plan 2'

insert into clone_lead
select *, 'RULE_345' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY OF WA'
and group_name in ('KAISER FOUNDATION','KP I&F FAM-PLAN 2')

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%DE%' then '{MM}'
when plan_type::text like '%DH%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_345'
;
-- 'Rule 346 - Clone Delta Dental Insurance Company of WA, KP MEDADVANTAGE'

insert into clone_lead
select *, 'RULE_346' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY OF WA'
and group_name = 'KP MEDADVANTAGE'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
group_number = '9300100',
group_name = 'KPWA MEDICARE ADVANTAGE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%DE%' then '{MC}'
when plan_type::text like '%DH%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_346'
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
-- 'Rule 348 - Clone OptumRX 84 Lumber'

insert into clone_lead
select *, 'RULE_348' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = '84 Lumber'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'LBM' || policy_ssn,
group_number = NULL,
group_name = upper(medical_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_348'
;
-- 'Rule 349 - Clone OptumRX CHRISTUS HEALTH'

insert into clone_lead
select *, 'RULE_349' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = 'CHRISTUS HEALTH'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = 'CHF' || policy_ssn,
group_number = NULL,
group_name = 'CHRISTUS HEALTH',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_349'
;
-- 'Rule 350 - Clone OptumRX 0270'

insert into clone_lead
select *, 'RULE_350' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0270'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF COLORADO',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_350'
;
-- 'Rule 351 - Clone OptumRX 0274'

insert into clone_lead
select *, 'RULE_351' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0274'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_351'
;
-- 'Rule 352 - Clone OptumRX 0269'

insert into clone_lead
select *, 'RULE_352' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0269'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF GEORGIA',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_352'
;
-- 'Rule 353 - Clone OptumRX 0275'

insert into clone_lead
select *, 'RULE_353' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0275'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE MID-ATLANTIC',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_353'
;
-- 'Rule 354 - Clone OptumRX 0273D'

insert into clone_lead
select *, 'RULE_354' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0273D'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_354'
;
-- 'Rule 355 - Clone OptumRX 0274D'

insert into clone_lead
select *, 'RULE_355' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0274D'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_355'
;
-- 'Rule 356 - Clone OptumRX 0270D'

insert into clone_lead
select *, 'RULE_356' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0270D'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF COLORADO',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_356'
;
-- 'Rule 357 - Clone OptumRX 0275D'

insert into clone_lead
select *, 'RULE_357' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0275D'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE MID-ATLANTIC',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_357'
;
-- 'Rule 358 - Clone OptumRX 0269D'

insert into clone_lead
select *, 'RULE_358' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0269D'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF GEORGIA',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_358'
;
-- 'Rule 359 - Clone OptumRX 0269D not KP3RX'

insert into clone_lead
select *, 'RULE_359' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = '0269D'
and coalesce(group_name,'') not like '%KP3RX%'

;
update clone_lead
set
carrier_name = 'HEALTH PLAN SERVICES',
member_id = left(member_id,9),
group_number = 'Q9',
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_359'
;
-- 'Rule 360 - Clone OptumRX PSI2658,PSI2687,0272,0273 not UHC,PACIFICARE,INDEMNITY'

insert into clone_lead
select *, 'RULE_360' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number in ('PSI2658','PSI2687','0272','0273')
and coalesce(policy_employer_name,'') not in ('UHC','PACIFICARE','INDEMNITY')

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_360'
;
-- 'Rule 361 - Clone OptumRX CDPHP'

insert into clone_lead
select *, 'RULE_361' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and policy_employer_name = 'CDPHP'

;
update clone_lead
set
carrier_name = 'CAPITAL DISTRICT PHYSICIAN''S HEALTH PLAN (CDPHP)',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_361'
;
-- 'Rule 362 - Clone OptumRX UPMC'

insert into clone_lead
select *, 'RULE_362' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and policy_employer_name = 'UPMC'

;
update clone_lead
set
carrier_name = 'UPMC',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_362'
;
-- 'Rule 363 - Clone Express_Scripts AV8A JCEA BUTLER HEALTH PLAN'

insert into clone_lead
select *, 'RULE_363' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (subgroup_number = 'AV8A'
or (subgroup_number = 'JCEA'
and group_name = 'BUTLER HEALTH PLAN'))

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_363'
;
-- 'Rule 364 - Clone Express_Scripts JCEA NBHP, OPTIMAL HEALTH INITIATIVE, CITY OF OXFORD, SEBT'

insert into clone_lead
select *, 'RULE_364' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'JCEA'
and group_name in ('NBHP','OPTIMAL HEALTH INITIATIVE', 'CITY OF OXFORD','SEBT')

;
update clone_lead
set
carrier_name = 'ALLIED BENEFIT SYSTEMS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_364'
;
-- 'Rule 365 - Clone Express_Scripts JCEA ALLEN CNTY'

insert into clone_lead
select *, 'RULE_365' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('KP4A','JCEA') --Added KP48 5/30/2019 DM19_Week8_Updates
and group_name = 'ALLEN CNTY'

;
update clone_lead
set
carrier_name = 'MEDICAL MUTUAL', --CHANGED FROM MEDICAL MUTUAL OF OHIO TO MEDICAL MUTUAL 5/30/2019 DM19_WEEK8_UPDATES
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_365'
;
-- 'Rule 366 - Clone OptumRX PSI3268'

insert into clone_lead
select *, 'RULE_366' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'PSI3268'

;
update clone_lead
set
carrier_name = 'AMERIBEN',
member_id = left(member_id,12),
group_number = NULL,
group_name = upper(medical_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_366'
;
-- 'Rule 367 - Clone Express_Scripts AMRGRPHTH %BCBS%'

insert into clone_lead
select *, 'RULE_367' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AMRGRPHTH'
and group_number like '%BCBS%'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = 'TXS' || policy_ssn,
group_number = NULL,
group_name = 'AMERICAN AIRLINES, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_367'
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
member_id = 'XJJ' || left(member_id,9),
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

insert into clone_lead
select *, 'RULE_369' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name in ('SANFORD HEALTH PLN COMM', 'SANFORD HEALTH PLN HIX', 'SANFORD HEALTH PLN NDPERS', 'SANFORD HEALTH PLN TPA')
;

-- 'Rule 369 - Clone Catamaran SANFORD HEALTH PLN COMM, SANFORD HEALTH PLN HIX, SANFORD HEALTH PLN NDPERS, SANFORD HEALTH PLN TPA'
--- ********** left off here 
--row_cnt = 0; --commenting out for rule migration


update clone_lead
set
carrier_name = 'SANFORD HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end,
plan_type_group = 'M'
where match_carrier_rule_id_extra = 'RULE_369'
;
-- 'Rule 370 - Clone Catamaran SWHP%'

insert into clone_lead
select *, 'RULE_370' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name like 'SWHP%'

;
update clone_lead
set
carrier_name = 'SCOTT AND WHITE HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_370'
;
-- 'Rule 371 - Clone Catamaran CTR000610 FRCSARX,ERCSARX'

insert into clone_lead
select *, 'RULE_371' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTR000610'
and subgroup_number not in ('FRCSARX', 'ERCSARX')

;
update clone_lead
set
carrier_name = 'EMBLEM HEALTH',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_371'
;
-- 'Rule 372 - Clone Catamaran MPDH5427 FH19052,FH19089'

insert into clone_lead
select *, 'RULE_372' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'MPDH5427'
and subgroup_number in ('FH19052', 'FH19089')

;
update clone_lead
set
carrier_name = 'FREEDOM HEALTH',
member_id = RIGHT(member_id,10),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_372'
;
-- 'Rule 373 - Clone Catamaran CTRAZTP04'

insert into clone_lead
select *, 'RULE_373' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTRAZTP04'

;
update clone_lead
set
carrier_name = 'UHA HEALTH INSURANCE',
group_number = NULL,
group_name = 'TEAMSTERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_373'
;
-- 'Rule 374 - Clone Catamaran CTRAZTP11'

insert into clone_lead
select *, 'RULE_374' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTRAZTP11'

;
update clone_lead
set
carrier_name = 'HAWAII MAINLAND ADMINISTRATORS (HMA)',
group_number = NULL,
group_name = 'TEAMSTERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_374'
;
-- 'Rule 375 - Clone OptumRX CITY OF KNOXVILLE'

insert into clone_lead
select *, 'RULE_375' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = 'CITY OF KNOXVILLE'

;
update clone_lead
set
carrier_name = 'BCBS TN',
member_id = 'KNX' || policy_ssn,
group_number = '111174',
group_name = 'CITY OF KNOXVILLE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_375'
;
-- 'Rule 376 - Clone CVS_Caremark JFP-BENEFIT MANAGEMENT'

insert into clone_lead
select *, 'RULE_376' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'JFP-BENEFIT MANAGEMENT'

;
update clone_lead
set
carrier_name = 'JFP BENEFIT MANAGEMENT',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_376'
;
-- 'Rule 377 - Clone CVS_Caremark WMI MUTUAL INSURANCE CO'

insert into clone_lead
select *, 'RULE_377' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'WMI MUTUAL INSURANCE CO'

;
update clone_lead
set
carrier_name = 'WMI MUTUAL INSURANCE CO.',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_377'
;
-- 'Rule 378 - Clone Catamaran RWTALLIED'

insert into clone_lead
select *, 'RULE_378' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTALLIED'

;
update clone_lead
set
carrier_name = 'ALLIED BENEFIT SYSTEMS',
member_id = NULL,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_378'
;
-- 'Rule 379 - Clone Catamaran CTR000060'

insert into clone_lead
select *, 'RULE_379' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTR000060'


;
update clone_lead
set
carrier_name = 'INSURANCE ADMINISTRATOR OF AMERICA',
member_id = left(member_id,9),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_379'
;
-- 'Rule 380 - Clone Catamaran HLHWF'

insert into clone_lead
select *, 'RULE_380' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'HLHWF'

;
update clone_lead
set
carrier_name = 'PACIFIC ADMINISTRATORS, INC.',
member_id = left(member_id,8),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_380'
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
-- 'Rule 382 - Clone OptumRX PSI3510'

insert into clone_lead
select *, 'RULE_382' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'PSI3510'

;
update clone_lead
set
carrier_name = 'UNITED HEALTHCARE',
member_id = left(member_id,9),
group_number = subgroup_number,
group_name = 'CITY OF MILWAUKEE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_382'
;
-- 'Rule 383 - Clone Express_Scripts LWACPDP'

insert into clone_lead
select *, 'RULE_383' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LWACPDP'

;
update clone_lead
set
carrier_name = 'LIFEWISE OF OREGON',
member_id = 'ZNU' || member_id,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_383'
;
-- 'Rule 384 - Clone OptumRX UHCSTRC01'

insert into clone_lead
select *, 'RULE_384' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'UHCSTRC01'

;
update clone_lead
set
carrier_name = 'UNITED HEALTHCARE',
member_id = left(member_id,7),
group_number = group_desc,
group_name = upper(medical_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{ST}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_384'
;
-- 'Rule 385 - Clone CVS_Caremark EMPLOYEE BNFITS ADM & MGT'

insert into clone_lead
select *, 'RULE_385' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'EMPLOYEE BNFITS ADM & MGT'

;
update clone_lead
set
carrier_name = 'EBA&M',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_385'
;
-- 'Rule 386 - Clone Delta Dental Insurance Company KAISER SBU'

insert into clone_lead
select *, 'RULE_386' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name = 'KAISER SBU'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%DE%' then '{MM}'
when plan_type::text like '%DH%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_386'
;
-- 'Rule 387 - Clone Delta Dental Insurance Company KPSA ADVANTAGE PLUS'

insert into clone_lead
select *, 'RULE_387' from cob_lead_staging
where carrier_name = 'DELTA DENTAL INSURANCE COMPANY'
and group_name = 'KPSA ADVANTAGE PLUS'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%DE%' then '{MC}'
when plan_type::text like '%DH%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_387'
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
-- 'Rule 389 - Clone CVS_Caremark JOHNS HOPKINS USFHP'

insert into clone_lead
select *, 'RULE_389' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'JOHNS HOPKINS USFHP'

;
update clone_lead
set
carrier_name = 'JOHNS HOPKINS USFHP',
member_id = left(member_id,9),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{TR}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_389'
;
-- 'Rule 390 - Clone Express_Scripts APSNMRX %HC%'

insert into clone_lead
select *, 'RULE_390' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'APSNMRX'
and group_number like '%HC%'

;
update clone_lead
set
carrier_name = 'BCBS NM (HCSC)',
member_id = NULL,
group_number = 'NMHCAPS',
group_name = 'ALBUQUERQUE PUBLIC SCHOOLS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_390'
;
-- 'Rule 391 - Clone Express_Scripts APSNMRX %BCBS%'

insert into clone_lead
select *, 'RULE_391' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'APSNMRX'
and group_number like '%BCBS%'

;
update clone_lead
set
carrier_name = 'BCBS NM (HCSC)',
member_id = 'YIE' || member_ssn,
group_number = 'L04121',
group_name = 'ALBUQUERQUE PUBLIC SCHOOLS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_391'
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
member_id = member_id || pbm_person_code,
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
-- 'Rule 393 - Clone CVS_Caremark BUILDING SRVS 32BJ HEALTH PHILADELPHIA'

insert into clone_lead
select *, 'RULE_393' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BUILDING SRVS 32BJ HEALTH'
and member_city = 'PHILADELPHIA'

;
update clone_lead
set
carrier_name = 'INDEPENDENCE BLUE CROSS',
member_id = NULL,
group_number = NULL,
group_name = 'BUILDING SERVICES 32BJ HEALTH FUND', --Changed from 'BUILDING SERVICES 32BJ HEALTH FND-METROPOLITAN' to 'BUILDING SERVICES 32BJ HEALTH FUND' 10/22/2019 per DM4.8_Week31_Updates TPLA-777
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_393'
;
-- 'Rule 394 - Clone CVS_Caremark BUILDING SRVS 32BJ HEALTH NOT PHILADELPHIA VA MD'

insert into clone_lead
select *, 'RULE_394' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BUILDING SRVS 32BJ HEALTH'
and coalesce(member_city, '') <> 'PHILADELPHIA'
and coalesce(member_state,'') not in ('VA','MD')

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'BUILDING SERVICES 32BJ HEALTH FUND', --Changed from 'BUILDING SERVICES 32BJ HEALTH FND-METROPOLITAN' to 'BUILDING SERVICES 32BJ HEALTH FUND' 10/22/2019 per DM4.8_Week31_Updates TPLA-777
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_394'
;
-- 'Rule 395 - Clone Express_Scripts NMPSIARX %BCBS%'

insert into clone_lead
select *, 'RULE_395' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NMPSIARX'
and group_number like '%BCBS%'

;
update clone_lead
set
carrier_name = 'BCBS NM (HCSC)',
member_id = 'NMJ' || member_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_395'
;
-- 'Rule 396 - Clone Express_Scripts ORWACRP'

insert into clone_lead
select *, 'RULE_396' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ORWACRP'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
member_id = NULL,
group_number = '10000187',
group_name = 'OREGON-WASHINGTON CARPENTERS-EMPLOYERS TRUST FUNDS', --50 Characters
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_396'
;
-- 'Rule 397 - Clone Express_Scripts BLEDSOE %ACTIVE%'

insert into clone_lead
select *, 'RULE_397' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BLEDSOE'
and group_number like '%ACTIVE%'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
member_id = NULL,
group_number = '10005699',
group_name = 'THE BLEDSOE HEALTH TRUST',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_397'
;
-- 'Rule 398 - Clone Express_Scripts BLEDSOE %RETIREE%'

insert into clone_lead
select *, 'RULE_398' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BLEDSOE'
and group_number like '%RETIREE%'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
member_id = NULL,
group_number = NULL,
group_name = 'THE BLEDSOE HEALTH TRUST',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_398'
;
-- 'Rule 399 - Clone Express_Scripts CISRX4U'

insert into clone_lead
select *, 'RULE_399' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CISRX4U'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_399'
;
-- 'Rule 400 - Clone Catamaran RXBHMAA'

insert into clone_lead
select *, 'RULE_400' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RXBHMAA'

;
update clone_lead
set
carrier_name = 'HAWAII MEDICAL ASSURANCE ASSOC (HMAA)',
member_id = left(member_id,9),
group_number = subgroup_number,
group_name = upper(group_desc),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_400'
;
-- 'Rule 401 - Clone Catamaran GROUP HEALTH ACA PLANS'

insert into clone_lead
select *, 'RULE_401' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'GROUP HEALTH ACA PLANS'

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN OF THE NW',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_401'
;
-- 'Rule 402 - Clone Express_Scripts NDFA'

insert into clone_lead
select *, 'RULE_402' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXBNEHE' --Changed 'NDFA' to 'RXBNEHE' 10/22/2019 per DM4.9_Week38_Updates TPLA-1009

;
update clone_lead
set
carrier_name = 'SHASTA ADMINISTRATIVE SERVICES',
group_number = NULL, --Changed from left(group_number,3) to NULL 10/22/2019 per DM4.9_Week38_Updates TPLA-1009
--group_name = 'NESIKA HEALTH GROUP CORP',  --Removed 10/22/2019 per DM4.9_Week38_Updates TPLA-1009
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_402'
;
-- 'Rule 403 - Clone Catamaran HEALTH NEW ENGLAND'

insert into clone_lead
select *, 'RULE_403' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'HEALTH NEW ENGLAND'

;
update clone_lead
set
carrier_name = 'HEALTH NEW ENGLAND',
member_id = NULL,
group_number = subgroup_number,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_403'
;
-- 'Rule 404 - Clone Catamaran PCHLTH'

insert into clone_lead
select *, 'RULE_404' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'PCHLTH'

;
update clone_lead
set
carrier_name = 'MERITAIN',
member_id = left(member_id,10),
group_number = NULL,
group_name = 'PEACEHEALTH',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_404'
;
-- 'Rule 405 - Clone Catamaran NWL01'

insert into clone_lead
select *, 'RULE_405' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'NWL01'

;
update clone_lead
set
carrier_name = 'ZENITH AMERICAN',  --CHANGED FROM ZENITH ADMINISTRATORS TO ZENITH AMERICAN 5/30/2019 DM19_WEEK10_UPDATES
member_id = left(member_id,12),  --Changed from LEFT(member_id,10) to LEFT(member_id,12) 5/30/2019 DM4.3_Week12_Updates
group_number = NULL,
group_name = 'NORTHWEST LABORERS HEALTH PLAN',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_405'
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
member_id = 'QCI' || left(member_id,9),
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
-- 'Rule 407 - Clone Express_Scripts 1199EGWP 1199MD 1199RX LICENSED PRACTICAL NURSES ROCHESTER'

insert into clone_lead
select *, 'RULE_407' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('1199MD', '1199RX') --Removed '1199EGWP' 10/21/2019 per DM4.4_Week17_Updates TPLA-258
and group_number in ('29861972', '2986198A', '2986198N', '2986199A', '2986199F', '2987197P', '2987199A', '5258199M', '5258199P')
--and coalesce(group_name,'') not in ('LICENSED PRACTICAL NURSES', 'ROCHESTER') --Removed and replaced with above line 10/21/2019 per DM4.4_Week17_Updates TPLA-258

;
update clone_lead
set
carrier_name = '1199 NATIONAL BENEFIT FUND',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_407'
;
-- 'Rule 408 - Clone MedImpact MHM'

insert into clone_lead
select *, 'RULE_408' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and subgroup_number = 'MHM'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS MO',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_408'
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
member_id = 'RHV' || left(member_id,9),
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
-- 'Rule 410 - Clone Express_Scripts SCPEBAX'

insert into clone_lead
select *, 'RULE_410' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SCPEBAX'

;
update clone_lead
set
carrier_name = 'BCBS SC',
member_id = 'ZCS' || member_id,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_410'
;
-- 'Rule 411 - Clone Catamaran Tall Tree Administration'

insert into clone_lead
select *, 'RULE_411' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'TALL TREE ADMINISTRATION'

;
update clone_lead
set
carrier_name = 'TALL TREE ADMINISTRATORS',
member_id = left(member_id,10),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_411'
;
-- 'Rule 412 - Clone CVS_Caremark SWSCHP COMMERCIAL'

insert into clone_lead
select *, 'RULE_412' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'SWSCHP COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ALICARE',
member_id = NULL,
group_number = 'TUR',
group_name = 'SWSCHP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_412'
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
member_id = 'UTS0' || left(member_id,8),
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
member_id = 'KMT' || left(member_id,9), --Changed from 'KMT' || RIGHT(member_id,9) to 'KMT' || LEFT(member_id,9) per DM4.6_Week24_Updates TPLA-520
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
-- 'Rule 415 - Clone Express_Scripts HALESGRX'

insert into clone_lead
select *, 'RULE_415' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HALESGRX'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = 'HBT' || policy_ssn,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_415'
;
-- 'Rule 416 - Clone CVS_Caremark CNC SC MAPD H1436'

insert into clone_lead
select *, 'RULE_416' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'CNC SC MAPD H1436'

;
update clone_lead
set
carrier_name = 'AMBETTER SC (ABSOLUTE TOTAL CARE)',
group_number = 'SC1436',
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_416'
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
member_id = 'CDK' || left(member_id,9),
group_number = '720059',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_417'
;
-- 'Rule 418 - Clone Benesys 920DEATH 920NODEATH'

insert into clone_lead
select *, 'RULE_418' from cob_lead_staging
where carrier_name = 'BENESYS'
AND group_number in ('920DEATH','920NODEATH')

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_418'
;
-- 'Rule 419 - Clone Express_Scripts BOONCHP'

insert into clone_lead
select *, 'RULE_419' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'BOONCHP'

;
update clone_lead
set
carrier_name = 'BOON-CHAPMAN',
member_id = policy_ssn,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_419'
;
-- 'Rule 420 - Clone Express_Scripts ACRA NCAS'

insert into clone_lead
select *, 'RULE_420' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'ACRA'
AND group_name = 'NCAS'

;
update clone_lead
set
carrier_name = 'NCAS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_420'
;
-- 'Rule 421 - Clone Express_Scripts LEHBRXS'

insert into clone_lead
select *, 'RULE_421' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'LEHBRXS'

;
update clone_lead
set
carrier_name = 'INDEPENDENCE BLUE CROSS',
member_id = 'LYW' || policy_ssn,
group_number = '10054253',
group_name = 'LAW ENFORCEMENT HEALTH BENEFIT GROUP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_421'
;
-- 'Rule 422 - Clone Catamaran LEHBRXS'

insert into clone_lead
select *, 'RULE_422' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTR000350'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = left(member_id,12),
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_422'
;
-- 'Rule 423 - Clone Express_Scripts MAGNARX1'

insert into clone_lead
select *, 'RULE_423' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'MAGNARX1'

;
update clone_lead
set
carrier_name = 'BCBS MI',
member_id = 'MZO' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_423'
;
-- 'Rule 424 - Clone Catamaran CTRPUBLIX'

insert into clone_lead
select *, 'RULE_424' from cob_lead_staging
where carrier_name = 'CATAMARAN'
AND medical_name = 'CTRPUBLIX'

;
update clone_lead
set
carrier_name = 'BCBS FL',
member_id = 'PXN' || policy_ssn,
group_number = NULL,
group_name = upper(group_number),
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_424'
;
-- 'Rule 425 - Clone Express_Scripts RCL4RXS'

insert into clone_lead
select *, 'RULE_425' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'RCL4RXS'

;
update clone_lead
set
carrier_name = 'BCBS FL',
member_id = 'RYQ' || policy_ssn,
group_number = NULL,
group_name = 'ROYAL CARIBBEAN CRUISES LTD',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_425'
;
-- 'Rule 426 - Clone Express_Scripts CAJWFRX'

insert into clone_lead
select *, 'RULE_426' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'CAJWFRX'

;
update clone_lead
set
carrier_name = 'BCBS MN',
member_id = 'WZZ' || member_id,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_426'
;
-- 'Rule 427 - Clone Express_Scripts BHE7235'

insert into clone_lead
select *, 'RULE_427' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND subgroup_number = 'BHE7235'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_427'
;
-- 'Rule 428 - Clone Express_Scripts CMS CONTRACT HEALTH INS P 2XS%, 4XS%, LXS%, XXS%'

insert into clone_lead
select *, 'RULE_428' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
AND group_name = 'CMS CONTRACT HEALTH INS P'
AND coalesce(group_number,'') not like '2XS%'
AND coalesce(group_number,'') not like '4XS%'
AND coalesce(group_number,'') not like 'LXS%'
AND coalesce(group_number,'') not like 'XXS%'

;
update clone_lead
set
carrier_name = 'EMBLEM HEALTH',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_428'
;
-- 'Rule 429 - Clone Express_Scripts 1199RX ROCHESTER'

insert into clone_lead
select *, 'RULE_429' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '1199RX'
and group_name = 'ROCHESTER'

;
update clone_lead
set
carrier_name = 'MVP HEALTH CARE',
member_id = member_ssn || '01',
group_number = NULL,
group_name = '1199 SEIU BENEFITS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_429'
;
-- 'Rule 430 - Clone Express_Scripts AMAZON1 FA%'

insert into clone_lead
select *, 'RULE_430' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AMAZON1'
and group_number like 'FA%'

;
update clone_lead
set
carrier_name = 'PREMERA BC WA',
member_id = 'AQT' || member_id,
group_number = '4000083',
group_name = 'AMAZON AND SUBSIDIARIES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_430'
;
-- 'Rule 431 - Clone Express_Scripts AVAMERE'

insert into clone_lead
select *, 'RULE_431' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AVAMERE'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = '10013076',
group_name = 'AVAMERE GROUP LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_431'
;
-- 'Rule 432 - Clone Express_Scripts RESRSRX'

insert into clone_lead
select *, 'RULE_432' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RESRSRX'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = '10012994',
group_name = 'RESERS FINE FOODS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_432'
;
-- 'Rule 433 - Clone Express_Scripts BSW8727 MY9A'

insert into clone_lead
select *, 'RULE_433' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('BSW8727', 'MY9A')

;
update clone_lead
set
carrier_name = 'BCBS LA',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_433'
;
-- 'Rule 434 - Clone MedImpact WIN01'

insert into clone_lead
select *, 'RULE_434' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
AND group_number = 'WIN01'

;
update clone_lead
set
carrier_name = 'REGENCE BS ID',
member_id = NULL,
group_number = '10034043',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_434'
;
-- 'Rule 435 - Clone Express_Scripts HALHAWT FLOWERS'

insert into clone_lead
select *, 'RULE_435' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('HALHAWT', 'FLOWERS')

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
group_number = left(group_number,10),
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_435'
;
-- 'Rule 436 - Clone Express_Scripts CUMMINS'

insert into clone_lead
select *, 'RULE_436' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CUMMINS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
group_number = NULL,
group_name = 'CUMMINS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_436'
;
-- 'Rule 437 - Clone Express_Scripts CPORTRX'

insert into clone_lead
select *, 'RULE_437' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CPORTRX'

;
update clone_lead
set
carrier_name = 'MODA HEALTH',
group_number = NULL,
group_name = 'CITY OF PORTLAND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_437'
;
-- 'Rule 438 - Clone Express_Scripts ERICKSON, INC.'

insert into clone_lead
select *, 'RULE_438' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'ERICKSON, INC.'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = '10012991',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_438'
;
-- 'Rule 439 - Clone Express_Scripts Willamette Dental'

insert into clone_lead
select *, 'RULE_439' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'WILLAMETTE DENTAL'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = '10002156',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_439'
;
-- 'Rule 440 - Clone Express_Scripts COLDIST'

insert into clone_lead
select *, 'RULE_440' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'COLDIST'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
group_number = '10029786',
group_name = 'COLUMBIA DISTRIBUTING',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_440'
;
-- 'Rule 441 - Clone Express_Scripts ZGP% BNN% EPN% HLV% IJU% SLR%'

insert into clone_lead
select *, 'RULE_441' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and (coalesce(member_id,'') like 'ZGP%'
OR coalesce(member_id,'') like 'BNN%'
OR coalesce(member_id,'') like 'EPN%'
OR coalesce(member_id,'') like 'HLV%'
OR coalesce(member_id,'') like 'IJU%'
OR coalesce(member_id,'') like 'SLR%')

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_441'
;
-- 'Rule 442 - Clone Express_Scripts SBHRX01'

insert into clone_lead
select *, 'RULE_442' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SBHRX01'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
group_number = '246237',
group_name = 'SALLY BEAUTY HOLDINGS, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_442'
;
-- 'Rule 443 - Clone Express_Scripts SULZERX'

insert into clone_lead
select *, 'RULE_443' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SULZERX'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
group_number = '097514',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_443'
;
-- 'Rule 444 - Clone Express_Scripts SEHOMES'

insert into clone_lead
select *, 'RULE_444' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SEHOMES'

;
update clone_lead
set
carrier_name = 'BCBS AL',
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_444'
;
-- 'Rule 445 - Clone Express_Scripts SHP8668'

insert into clone_lead
select *, 'RULE_445' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SHP8668'

;
update clone_lead
set
carrier_name = 'SUTTER HEALTH PLUS',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_445'
;
-- 'Rule 446 - Clone Express_Scripts NDCPRXS'

insert into clone_lead
select *, 'RULE_446' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NDCPRXS'

;
update clone_lead
set
carrier_name = 'BCBS VT',
group_number = '50625',
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_446'
;
-- 'Rule 447 - Clone Express_Scripts SCHRXS1'

insert into clone_lead
select *, 'RULE_447' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SCHRXS1'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS WA',
group_number = '10017649',
group_name = 'SEATTLE CHILDRENS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_447'
;
-- 'Rule 448 - Clone Express_Scripts NASIMDX'

insert into clone_lead
select *, 'RULE_448' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NASIMDX'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = left(member_id,12),
group_number = 'P14558',
group_name = 'NATIONAL AUTOMATIC SPRINKLER INDUSTRY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_448'
;
-- 'Rule 449 - Clone Express_Scripts NASIRXP'

insert into clone_lead
select *, 'RULE_449' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NASIRXP'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = left(member_id,12),
group_number = 'P14560',
group_name = 'NATL AUTOMATIC SPRINKLER METAL TRADES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_449'
;
-- 'Rule 450 - Clone Express_Scripts INGREDN'

insert into clone_lead
select *, 'RULE_450' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'INGREDN'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
group_number = left(group_number,6),
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_450'
;
-- 'Rule 451 - Clone Express_Scripts BBURX01'

insert into clone_lead
select *, 'RULE_451' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BBURX01'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
group_number = left(group_number,6),
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_451'
;
-- 'Rule 452 - Clone Express_Scripts KIRBYRX'

insert into clone_lead
select *, 'RULE_452' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'KIRBYRX'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
group_number = left(group_number,6),
group_name = 'KIRBY CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_452'
;
-- 'Rule 453 - Clone Express_Scripts WOODGRX BCBS TX PLAN'

insert into clone_lead
select *, 'RULE_453' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WOODGRX'
and group_number = 'BCBS TX PLAN'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = 'WXX' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_453'
;
-- 'Rule 454 - Clone Catamaran STATE OF IL EMPLOYEES'

insert into clone_lead
select *, 'RULE_454' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'STATE OF IL EMPLOYEES'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = RIGHT(member_id,12),
group_number = 'P15934',
group_name = 'TEAMSTER & EMPLOYERS WELFARE TRUST OF IL',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_454'
;
-- 'Rule 455 - Clone CVS_Caremark TIMBER PRODUCTS COMPANY'

insert into clone_lead
select *, 'RULE_455' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'TIMBER PRODUCTS COMPANY'

;
update clone_lead
set
carrier_name = 'REGENCE BCBS OR',
member_id = NULL,
group_number = '10012547',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_455'
;
-- 'Rule 456 - Clone Express_Scripts L1098RX'

insert into clone_lead
select *, 'RULE_456' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'L1098RX'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'LAQ' || member_id,
group_number = 'P30481',
group_name = 'LOUSIANA CARPENTERS HEALTH BENEFIT FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_456'
;
-- 'Rule 457 - Clone CVS_Caremark TRINITY HEALTH'

insert into clone_lead
select *, 'RULE_457' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'TRINITY HEALTH'

;
update clone_lead
set
carrier_name = 'BCBS MI',
member_id = 'TIY' || policy_ssn,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_457'
;
-- 'Rule 458 - Clone Express_Scripts BOEING1 BOE NONUNION ACT AET HMO'

insert into clone_lead
select *, 'RULE_458' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BOEING1'
and coalesce(group_name,'') <> 'BOE NONUNION ACT AET HMO'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'BBE' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_458'
;
-- 'Rule 459 - Clone Express_Scripts RXB TREE TOP INC'

insert into clone_lead
select *, 'RULE_459' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'RXB TREE TOP INC'

;
update clone_lead
set
carrier_name = 'HEALTHCOMP',
member_id = NULL,
group_number = '735',
group_name = 'TREE TOP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_459'
;
-- 'Rule 460 - Clone Express_Scripts CHARTER %M%'

insert into clone_lead
select *, 'RULE_460' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CHARTER'
and policy_id like '%M%'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS MO',
member_id = 'UCR' || member_id,
group_number = NULL,
group_name = 'CHARTER COMMUNICATIONS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_460'
;
-- 'Rule 461 - Clone Express_Scripts BOEINGD not BNASLRY EGWP AET MED ADV'

insert into clone_lead
select *, 'RULE_461' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BOEINGD'
and coalesce(group_name,'') <> 'BNASLRY EGWP AET MED ADV'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'BEM' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_461'
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
member_id = member_id || '0' || pbm_person_code,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_462'
;
-- 'Rule 463 - Clone MedImpact KT412 KROGER PRESCRIPTION PLANS (KPP'

insert into clone_lead
select *, 'RULE_463' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_number = 'KT412'
and group_name = 'KROGER PRESCRIPTION PLANS (KPP'

;
update clone_lead
set
carrier_name = 'WILLIAM C EARHART CO',
member_id = member_id || '*0',
group_number = '45',
group_name = 'OREGON LABORERS-EMPLOYERS TRUST FUNDS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_463'
;
-- 'Rule 464 - Clone Catamaran CTR000370'

insert into clone_lead
select *, 'RULE_464' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'CTR000370'

;
update clone_lead
set
carrier_name = 'BCBS MI',
member_id = 'MSR' || policy_ssn,
group_number = NULL,
group_name = 'MICHIGAN PUBLIC SCHOOL EMPLOYE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_464'
;
-- 'Rule 465 - Clone Express_Scripts CTYYORK'

insert into clone_lead
select *, 'RULE_465' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CTYYORK'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'ZAR' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_465'
;
-- 'Rule 466 - Clone CVS_Caremark NHPRI INDIVIDUAL% NHPRI SMALL GROUP ON'

insert into clone_lead
select *, 'RULE_466' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'NHPRI INDIVIDUAL%' or group_name = 'NHPRI SMALL GROUP ON')

;
update clone_lead
set
carrier_name = 'NEIGHBORHOOD HEALTH PLAN OF RHODE ISLAND',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_466'
;
-- 'Rule 467 - Clone Express_Scripts WERNER1'

insert into clone_lead
select *, 'RULE_467' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WERNER1'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'WQH' || policy_ssn,
group_number = '08408901',
group_name = 'MERCER/PE WERNER ENTERPRISES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_467'
;
-- 'Rule 468 - Clone Express_Scripts SYSC001'

insert into clone_lead
select *, 'RULE_468' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'SYSC001'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'SYY' || member_id,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_468'
;
-- 'Rule 469 - Clone Express_Scripts LKQ8770'

insert into clone_lead
select *, 'RULE_469' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LKQ8770'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'LKQ' || member_id,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_469'
;
-- 'Rule 470 - Clone CVS_Caremark CNC % %HIM NC%'

insert into clone_lead
select *, 'RULE_470' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name LIKE 'CNC %'
and group_name LIKE '%HIM NC%'

;
update clone_lead
set
carrier_name = 'AMBETTER NC (AMBETTER OF NORTH CAROLINA, INC.)',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_470'
;
-- 'Rule 471 - Clone CVS_Caremark CNC % %HIM TN%'

insert into clone_lead
select *, 'RULE_471' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name LIKE 'CNC %'
and group_name LIKE '%HIM TN%'

;
update clone_lead
set
carrier_name = 'AMBETTER TN (AMBETTER OF TENNESSEE)',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_471'
;
-- 'Rule 472 - Clone Express_Scripts VZNORTH %Anthem%'

insert into clone_lead
select *, 'RULE_472' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'VZNORTH'
and group_name like '%ANTHEM%'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'UQV' || policy_ssn,
group_number = NULL,
group_name = 'VERIZON NY/NE ASSOCIATES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_472'
;
-- 'Rule 473 - Clone Express_Scripts VZSOUTH VERIZON %Anthem%'

insert into clone_lead
select *, 'RULE_473' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number in ('VZSOUTH','VERIZON')
and group_name like '%ANTHEM%'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS VA',
member_id = 'DZV' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_473'
;
-- 'Rule 474 - Clone CVS_Carmark CAPITAL ONE'

insert into clone_lead
select *, 'RULE_474' from cob_lead_staging
where carrier_name = 'CVS_CARMARK'
and group_name = 'CAPITAL ONE'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS VA',
member_id = left(member_id,12),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_474'
;
-- 'Rule 475 - Clone CVS_Caremark FRANKS INTERNATIONAL'

insert into clone_lead
select *, 'RULE_475' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'FRANKS INTERNATIONAL'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = left(member_id,12),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_475'
;
-- 'Rule 476 - Clone CVS_Caremark TEMPLE UNIVERSITY'

insert into clone_lead
select *, 'RULE_476' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'TEMPLE UNIVERSITY'

;
update clone_lead
set
carrier_name = 'INDEPENDENCE BLUE CROSS',
member_id = 'QCI' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_476'
;
-- 'Rule 477 - Clone CVS_Caremark ZACHRY HOLDINGS'

insert into clone_lead
select *, 'RULE_477' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'ZACHRY HOLDINGS'

;
update clone_lead
set
carrier_name = 'BCBS TX (HCSC)',
member_id = 'AZH' || policy_ssn,
group_number = '151632',
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_477'
;
-- 'Rule 478 - Clone CVS_Caremark US FOODS US FOODS CDH'

insert into clone_lead
select *, 'RULE_478' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('US FOODS','US FOODS CDH')

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'UST' || policy_ssn,
group_number = NULL,
group_name = 'US FOODS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_478'
;
-- 'Rule 479 - Clone CVS_Caremark CATHOLIC HEALTH INIT. IN KY'

insert into clone_lead
select *, 'RULE_479' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'CATHOLIC HEALTH INIT.'
and member_state in ('IN','KY')

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS IN',
member_id = 'CHL' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_479'
;
-- 'Rule 480 - Clone CVS_Caremark CATHOLIC HEALTH INIT. AR IA IN KY NE TX'

insert into clone_lead
select *, 'RULE_480' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'CATHOLIC HEALTH INIT.'
and coalesce(member_state,'') NOT IN ('AR', 'IA', 'IN', 'KY', 'NE', 'TX')

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = 'CHV' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_480'
;
-- 'Rule 481 - Clone Catamaran NFRB'

insert into clone_lead
select *, 'RULE_481' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'NFRB'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = left(member_id,12),
group_number = '003320975',
group_name = 'NOVELIS CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_481'
;
-- 'Rule 482 - Clone Catamaran ANTHEM%'

insert into clone_lead
select *, 'RULE_482' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like 'ANTHEM%'
and policy_employer_name = 'L BRANDS INC' --Added 10/22/2019 per DM4.7_Week30_Updates TPLA-689

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = left(member_id,12),
group_number = '003320013',
group_name = 'L BRANDS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_482'
;
-- 'Rule 483 - Clone Catamaran ANDERSONS ACTIVE%'

insert into clone_lead
select *, 'RULE_483' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like 'ANDERSONS ACTIVE%'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = policy_ssn,
group_number = '004007685',
group_name = 'THE ANDERSONS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_483'
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
group_number = 'S' || left(group_number,4),
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
-- 'Rule 485 - Clone OptumRX Tender Touch Rehab Servic PROACTHM'

insert into clone_lead
select *, 'RULE_485' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and policy_employer_name = 'TENDER TOUCH REHAB SERVIC'
and group_number = 'PROACTHM'

;
update clone_lead
set
carrier_name = 'AMERICAN PLAN ADMINISTRATORS',
member_id = NULL,
group_number = '32130',
group_name = 'TENDER TOUCH REHAB SERVICES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_485'
;
-- 'Rule 486 - Clone Express_Scripts 85963'

insert into clone_lead
select *, 'RULE_486' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '85963'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '009500019',
group_name = 'AIR WISCONSIN AIRLINES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_486'
;
-- 'Rule 487 - Clone Express_Scripts AEPUMBR %AN%'

insert into clone_lead
select *, 'RULE_487' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AEPUMBR'
and member_id like '%AN%'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003321350',
group_name = 'AMERICAN ELECTRIC POWER',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_487'
;
-- 'Rule 488 - Clone Express_Scripts AKIMARX'

insert into clone_lead
select *, 'RULE_488' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AKIMARX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = left(member_id,12),
group_number = '009230505',
group_name = 'AKIMA LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_488'
;
-- 'Rule 489 - Clone Express_Scripts ALLISON'

insert into clone_lead
select *, 'RULE_489' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ALLISON'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003321960',
group_name = 'ALLISON TRANSMISSION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_489'
;
-- 'Rule 490 - Clone Express_Scripts BLOCKRX'

insert into clone_lead
select *, 'RULE_490' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BLOCKRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003330013',
group_name = 'H&R BLOCK',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_490'
;
-- 'Rule 491 - Clone Express_Scripts CNOSVRX'

insert into clone_lead
select *, 'RULE_491' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CNOSVRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004009906',
group_name = 'CNO SERVICES, LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_491'
;
-- 'Rule 492 - Clone Express_Scripts DAVISHE'

insert into clone_lead
select *, 'RULE_492' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'DAVISHE'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007239',
group_name = 'DAVIS H. ELLIOT CONST COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_492'
;
-- 'Rule 493 - Clone Express_Scripts EKUA'

insert into clone_lead
select *, 'RULE_493' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EKUA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004004196',
group_name = 'EASTERN KENTUCKY UNIVERSITY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_493'
;
-- 'Rule 494 - Clone Express_Scripts KERRYRX'

insert into clone_lead
select *, 'RULE_494' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'KERRYRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003320400',
group_name = 'KERRY AMERICAS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_494'
;
-- 'Rule 495 - Clone Express_Scripts KONCRAN'

insert into clone_lead
select *, 'RULE_495' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'KONCRAN'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004009992',
group_name = 'KCI HOLDING USA, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_495'
;
-- 'Rule 496 - Clone Express_Scripts LACA'

insert into clone_lead
select *, 'RULE_496' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LACA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007654',
group_name = 'SPIRE SERVICES INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_496'
;
-- 'Rule 497 - Clone Express_Scripts LSSLVNG'

insert into clone_lead
select *, 'RULE_497' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LSSLVNG'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004009901',
group_name = 'LUTHERAN SENIOR SERVICES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_497'
;
-- 'Rule 498 - Clone Express_Scripts LSVA'

insert into clone_lead
select *, 'RULE_498' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LSVA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007725',
group_name = 'UNIVERSITY OF LOUISVILLE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_498'
;
-- 'Rule 499 - Clone Express_Scripts PERF001'

insert into clone_lead
select *, 'RULE_499' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PERF001'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007819',
group_name = 'PERFICIENT, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_499'
;
-- 'Rule 500 - Clone Express_Scripts PRADRUG'

insert into clone_lead
select *, 'RULE_500' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PRADRUG'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '009230506',
group_name = 'PRA GROUP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_500'
;
-- 'Rule 501 - Clone Express_Scripts REPBLIC'

insert into clone_lead
select *, 'RULE_501' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'REPBLIC'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003320031',
group_name = 'REPUBLIC AIRLINE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_501'
;
-- 'Rule 502 - Clone Express_Scripts RSMRX4U'

insert into clone_lead
select *, 'RULE_502' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RSMRX4U'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003330014',
group_name = 'RSM US LLP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_502'
;
-- 'Rule 503 - Clone Express_Scripts RXBHIDA'

insert into clone_lead
select *, 'RULE_503' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXBHIDA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003320001',
group_name = 'HILAND DAIRY FOODS,LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_503'
;
-- 'Rule 504 - Clone Express_Scripts RXBSHEB'

insert into clone_lead
select *, 'RULE_504' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXBSHEB'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '009500003',
group_name = 'SHEBOYGAN AREA SCHOOL DISTRICT',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_504'
;
-- 'Rule 505 - Clone Express_Scripts RXWELS'

insert into clone_lead
select *, 'RULE_505' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXWELS'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003325100',
group_name = 'THE WELS VEBA GRP HLT CARE PLN',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_505'
;
-- 'Rule 506 - Clone Express_Scripts STLCO14'

insert into clone_lead
select *, 'RULE_506' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'STLCO14'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004000999',
group_name = 'ST. LOUIS COUNTY, MISSOURI',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_506'
;
-- 'Rule 507 - Clone Express_Scripts TTINARX'

insert into clone_lead
select *, 'RULE_507' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'TTINARX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003321965',
group_name = 'TECHTRONIC INDUSTRIES NORTH AM',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_507'
;
-- 'Rule 508 - Clone Express_Scripts UNIVLPH'

insert into clone_lead
select *, 'RULE_508' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'UNIVLPH'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007905',
group_name = 'UNIVERSITY OF LOUISVILLE PHYS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_508'
;
-- 'Rule 509 - Clone Express_Scripts VALRX01'

insert into clone_lead
select *, 'RULE_509' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'VALRX01'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '003320049',
group_name = 'VALVOLINE LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_509'
;
-- 'Rule 510 - Clone Express_Scripts WESTKYU'

insert into clone_lead
select *, 'RULE_510' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WESTKYU'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = '004007217',
group_name = 'WESTERN KENTUCKY UNIVERSITY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_510'
;
-- 'Rule 511 - Clone Express_Scripts 35242RX PLY GEM INDUSTRIES'

insert into clone_lead
select *, 'RULE_511' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '35242RX'
and group_name = 'PLY GEM INDUSTRIES'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'UYG' || policy_ssn,
group_number = NULL,
group_name = 'PLY GEM INDUSTRIES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_511'
;
-- 'Rule 512 - Clone Express_Scripts 4802556'

insert into clone_lead
select *, 'RULE_512' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '4802556'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'LZJ' || policy_ssn,
group_number = '003323550',
group_name = 'SENTRY INSURANCE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_512'
;
-- 'Rule 513 - Clone Express_Scripts ARDAGH1'

insert into clone_lead
select *, 'RULE_513' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ARDAGH1'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'GTF' || policy_ssn,
group_number = '003330052',
group_name = 'ARDAGH GROUP',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_513'
;
-- 'Rule 514 - Clone Express_Scripts ARHA'

insert into clone_lead
select *, 'RULE_514' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ARHA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'ARJ' || policy_ssn,
group_number = '003320016',
group_name = 'ARCH COAL, INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_514'
;
-- 'Rule 515 - Clone Express_Scripts ASHRX01'

insert into clone_lead
select *, 'RULE_515' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ASHRX01'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'LDQ' || policy_ssn,
group_number = '003320650',
group_name = 'ASHLAND INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_515'
;
-- 'Rule 516 - Clone Express_Scripts AWANERX'

insert into clone_lead
select *, 'RULE_516' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'AWANERX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'KFV' || policy_ssn,
group_number = NULL,
group_name = 'SUMMIT MATERIALS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_516'
;
-- 'Rule 517 - Clone Express_Scripts BUNGERX'

insert into clone_lead
select *, 'RULE_517' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BUNGERX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'BUE' || policy_ssn,
group_number = '003320950',
group_name = 'BUNGE NORTH AMERICA',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_517'
;
-- 'Rule 518 - Clone Express_Scripts BWXTECH'

insert into clone_lead
select *, 'RULE_518' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BWXTECH'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'BWT' || policy_ssn,
group_number = NULL,
group_name = 'BWXT INVESTMENT COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_518'
;
-- 'Rule 519 - Clone Express_Scripts CFBA'

insert into clone_lead
select *, 'RULE_519' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CFBA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'MKG' || policy_ssn,
group_number = '003330055',
group_name = 'CREDIT SUISSE',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_519'
;
-- 'Rule 520 - Clone Express_Scripts CWGSRXS %ANTHEM'

insert into clone_lead
select *, 'RULE_520' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CWGSRXS'
and group_name like '%ANTHEM'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'RAH' || policy_ssn,
group_number = '003330053',
group_name = 'CWGS HEALTH & WELFARE PLAN',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_520'
;
-- 'Rule 521 - Clone Express_Scripts D5MA'

insert into clone_lead
select *, 'RULE_521' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'D5MA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'IDJ' || policy_ssn,
group_number = '009230018',
group_name = 'DOMINION ENERGY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_521'
;
-- 'Rule 522 - Clone Express_Scripts D8FA'

insert into clone_lead
select *, 'RULE_522' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'D8FA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'ALX' || policy_ssn,
group_number = '003330043',
group_name = 'ALLY FINANCIAL',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_522'
;
-- 'Rule 523 - Clone Express_Scripts EAINCRX'

insert into clone_lead
select *, 'RULE_523' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EAINCRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'EAL' || policy_ssn,
group_number = '003323755',
group_name = 'ETHAN ALLEN GLOBAL, INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_523'
;
-- 'Rule 524 - Clone Express_Scripts FOLLETT'

insert into clone_lead
select *, 'RULE_524' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'FOLLETT'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'FEZ' || policy_ssn,
group_number = '003320550',
group_name = 'FOLLETT CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_524'
;
-- 'Rule 525 - Clone Express_Scripts FRCOMM1'

insert into clone_lead
select *, 'RULE_525' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'FRCOMM1'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'CZC' || policy_ssn,
group_number = '003326812',
group_name = 'FRONTIER COMMUNICATIONS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_525'
;
-- 'Rule 526 - Clone Express_Scripts GORACER'

insert into clone_lead
select *, 'RULE_526' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'GORACER'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'MSU' || policy_ssn,
group_number = '004007243',
group_name = 'MURRAY STATE UNIVERSITY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_526'
;
-- 'Rule 527 - Clone Express_Scripts MEDESRX'

insert into clone_lead
select *, 'RULE_527' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'MEDESRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'EZE' || policy_ssn,
group_number = '003324250',
group_name = 'EXPRESS SCRIPTS, INC', --Changed from group_name = 'EXPRESS SCRIPTS, INC' to group_name = 'EXPRESS SCRIPTS, INCT' 10/21/2019 per DM4.6_Week26_Updates TPLA-550 --This is error confirmed 10/24/2019.  Changed back.
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_527'
;
-- 'Rule 528 - Clone Express_Scripts N86A'

insert into clone_lead
select *, 'RULE_528' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'N86A'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'AKZ' || policy_ssn,
group_number = '006000034',
group_name = 'THE WILLIAM CARTER COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_528'
;
-- 'Rule 529 - Clone Express_Scripts TOYOTA'

insert into clone_lead
select *, 'RULE_529' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'TOYOTA'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'TOA' || policy_ssn,
group_number = '003320100',
group_name = 'TOYOTA MOTOR NORTH AMERICA',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_529'
;
-- 'Rule 530 - Clone Express_Scripts XYLEMRX'

insert into clone_lead
select *, 'RULE_530' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'XYLEMRX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'ITP' || policy_ssn,
group_number = '003330075',
group_name = 'XYLEM INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_530'
;
-- 'Rule 531 - Clone Express_Scripts Z85A'

insert into clone_lead
select *, 'RULE_531' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'Z85A'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'IQW' || policy_ssn,
group_number = '006000036',
group_name = 'IMERYS, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_531'
;
-- 'Rule 532 - Clone Express_Scripts ZMHRXS1'

insert into clone_lead
select *, 'RULE_532' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ZMHRXS1'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'UHZ' || policy_ssn,
group_number = '003329200',
group_name = 'ZIMMER BIOMET HOLDINGS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_532'
;
-- 'Rule 533 - Clone Express_Scripts ABPLAN'

insert into clone_lead
select *, 'RULE_533' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ABPLAN'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'UXQ' || policy_ssn,
group_number = NULL,
group_name = 'ANHEUSER-BUSCH COMPANIES LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_533'
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
member_id = CASE
when group_name = 'RETIRED UNION OPEN' and left(coalesce(policy_ssn,''),3) = 'UVN' then policy_ssn
when group_name = 'RETIRED UNION OPEN' and left(coalesce(policy_ssn,''),3) <> 'UVN' then 'AMD' || policy_ssn
when coalesce(group_name,'') <> 'RETIRED UNION OPEN' and left(coalesce(member_id,''),3) <> 'UVN' then 'AMD' || member_id
else member_id end,
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
-- 'Rule 535 - Clone Express_Scripts BERTRX1'

insert into clone_lead
select *, 'RULE_535' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BERTRX1'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_535'
;
-- 'Rule 536 - Clone Express_Scripts EQUINOX'

insert into clone_lead
select *, 'RULE_536' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EQUINOX'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = 'EQK' || policy_ssn,
group_number = NULL,
group_name = 'EQUINOX HOLDINGS, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_536'
;
-- 'Rule 537 - Clone Express_Scripts PRICECP'

insert into clone_lead
select *, 'RULE_537' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PRICECP'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
group_number = NULL,
group_name = 'PRICE CHOPPER/MARKET 32',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_537'
;
-- 'Rule 538 - Clone CVS_Caremark CNC % HIM PA'

insert into clone_lead
select *, 'RULE_538' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CNC %'
and group_name like 'HIM PA'

;
update clone_lead
set
carrier_name = 'AMBETTER PA (PA HEALTH & WELLNESS PLAN)',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_538'
;
-- 'Rule 539 - Clone Express_Scripts BCBS OF NEBRASKA'

insert into clone_lead
select *, 'RULE_539' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'BCBS OF NEBRASKA'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'ARO' || member_id,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_539'
;
-- 'Rule 540 - Clone PREFERREDONE PP'

insert into clone_lead
select *, 'RULE_540' from cob_lead_staging
where carrier_name = 'PREFERREDONE'
and plan_type::text like  '%PP%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '600428',
pbm_pcn  = '06810000',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_540'
;
-- 'Rule 541 - Clone ESSENCE HEALTHCARE MC'

insert into clone_lead
select *, 'RULE_541' from cob_lead_staging
where carrier_name = 'ESSENCE HEALTHCARE'
and plan_type::text like  '%MC%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '012353',
pbm_pcn  = '02750000',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_541'
;
-- 'Rule 542 - Clone PROVIDENCE HEALTH PLAN MC'

insert into clone_lead
select *, 'RULE_542' from cob_lead_staging
where carrier_name = 'PROVIDENCE HEALTH PLAN'
and plan_type::text like '%MC%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '012353',
pbm_pcn  = '03300000',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_542'
;
-- 'Rule 543 - Clone PROVIDENCE HEALTH PLAN MM'

insert into clone_lead
select *, 'RULE_543' from cob_lead_staging
where carrier_name = 'PROVIDENCE HEALTH PLAN'
and plan_type::text like  '%MM%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '600428',
pbm_pcn  = '01420000',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_543'
;
-- 'Rule 544 - Clone VANTAGE HEALTH PLAN MC'

insert into clone_lead
select *, 'RULE_544' from cob_lead_staging
where carrier_name = 'VANTAGE HEALTH PLAN'
and plan_type::text like  '%MC%'

;
update clone_lead
set
carrier_name = 'NAVITUS PHARMACY BENEFITS',
group_number = 'VHD', --Changed from NULL to 'VHD' 10/22/2019 per DM4.7_Week29_Updates TPLA-658
pbm_bin  = '610602',
pbm_pcn  = 'NVTD',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_544'
;
-- 'Rule 545 - Clone VANTAGE HEALTH PLAN MM HM'

insert into clone_lead
select *, 'RULE_545' from cob_lead_staging
where carrier_name = 'VANTAGE HEALTH PLAN'
and (plan_type::text like '%MM%'or plan_type::text like '%HM%')

;
update clone_lead
set
carrier_name = 'NAVITUS PHARMACY BENEFITS',
group_number = case when policy_employer_name like '%OFF%' then 'VTGOX'
when policy_employer_name like '%ON%' then 'VTGX'
else 'VTGC' end, --Changed from NULL 10/22/2019 per DM4.7_Week29_Updates TPLA-658
pbm_bin  = '610602',
pbm_pcn  = 'NVT',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_545'
;
-- 'Rule 546 - Clone HOMETOWN HEALTH MC'

insert into clone_lead
select *, 'RULE_546' from cob_lead_staging
where carrier_name = 'HOMETOWN HEALTH'
and plan_type::text like  '%MC%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '019059',
pbm_pcn  = '07570000',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_546'
;
-- 'Rule 547 - Clone HOMETOWN HEALTH MM'

insert into clone_lead
select *, 'RULE_547' from cob_lead_staging
where carrier_name = 'HOMETOWN HEALTH'
and plan_type::text like  '%MM%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '019059',
pbm_pcn  = '07570000',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_547'
;
-- 'Rule 548 - Clone CIGNA MC'

insert into clone_lead
select *, 'RULE_548' from cob_lead_staging
where carrier_name = 'CIGNA'
and plan_type::text like  '%MC%'

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
group_number = NULL,
pbm_bin  = '012353',
pbm_pcn  = '03500000',
plan_type = '{MD}'
where match_carrier_rule_id_extra = 'RULE_548'
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
member_id = 'NMU' || left(member_id, 9),
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
-- 'Rule 550 - Clone Express_Scripts RXTRUCK'

insert into clone_lead
select *, 'RULE_550' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXTRUCK'

;
update clone_lead
set
carrier_name = 'BCBS TN',
member_id = left(member_id, 12),
group_number = '99336',
group_name = 'U S XPRESS ENTERPRISES INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_550'
;
-- 'Rule 551 - Clone CVS_Caremark BRIDGESTONE'

insert into clone_lead
select *, 'RULE_551' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BRIDGESTONE'

;
update clone_lead
set
carrier_name = 'BCBS TN',
member_id = 'BFE' || policy_ssn,
group_number = NULL,
group_name = 'BRIDGESTONE AMERICAS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_551'
;
-- 'Rule 552 - Clone CVS_Caremark INGRX-CA COMMERCIAL'

insert into clone_lead
select *, 'RULE_552' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-CA COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BC CA',
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
where match_carrier_rule_id_extra = 'RULE_552'
;
-- 'Rule 553 - Clone CVS_Caremark INGRX-CO COMMERCIAL'

insert into clone_lead
select *, 'RULE_553' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-CO COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS CO',
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
where match_carrier_rule_id_extra = 'RULE_553'
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
member_id = CASE
when member_id like 'AN%' then 'TRN' || left(member_id, 9)
else left(member_id, 10) end,
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
member_id = CASE
when member_id like 'AN%' then 'YCM' || left(member_id, 9)
when member_id like 'SKG%' then member_id
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then 'JIN' || left(member_id, 9)
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then 'KFQ' || left(member_id, 9)
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then left(member_id, 9)
else left(member_id, 10) end,
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
member_id = CASE
when member_id like 'AN%' then 'OZA' || left(member_id, 9)
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then 'LHR' || left(member_id, 9)
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then 'EHK' || left(member_id, 9)
else left(member_id, 10) end,
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
-- 'Rule 562 - Clone CVS_Caremark INGRX-NV COMMERCIAL'

insert into clone_lead
select *, 'RULE_562' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-NV COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS NV',
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
where match_carrier_rule_id_extra = 'RULE_562'
;
-- 'Rule 563 - Clone CVS_Caremark INGRX-NY COMMERCIAL'

insert into clone_lead
select *, 'RULE_563' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-NY COMMERCIAL'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
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
where match_carrier_rule_id_extra = 'RULE_563'
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
member_id = CASE
when member_id like 'AN%' then 'AGX' || left(member_id, 9)
else left(member_id, 9) end,
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
member_id = CASE
when member_id like 'AN%' then 'RTB' || left(member_id, 9)
else left(member_id, 9) end,
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
and (substring(member_id,8,2) = 'LC' or substring(member_id,8,2) = 'XU')

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
member_id = CASE
when member_id like 'AN%' then 'PTV' || left(member_id, 9)
else left(member_id, 9) end,
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
-- 'Rule 568 - Clone CVS_Caremark INGRX-GA COMMERCIAL'

insert into clone_lead
select *, 'RULE_568' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INGRX-GA COMMERCIAL'
and policy_id like 'SKG%'

;
update clone_lead
set
carrier_name = 'ANTHEM CENTRAL REGION',
member_id = left(member_id, 12),
group_number = NULL,
group_name = 'SOUTHEASTERN IRON WORKERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_568'
;
-- 'Rule 569 - Clone Express_Scripts EBRPSS1'

insert into clone_lead
select *, 'RULE_569' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EBRPSS1'

;
update clone_lead
set
carrier_name = 'BCBS LA',
member_id = NULL,
group_number = NULL,
group_name = 'EAST BATON ROUGE PARISH SCHOOL SYSTEM',
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_569'
;
-- 'Rule 570 - Clone WelldyneRX CITY OF%, DOUGLAS COUNTY% or WASHOE COUNTY%'

insert into clone_lead
select *, 'RULE_570' from cob_lead_staging
where carrier_name = 'WELLDYNERX'
and (group_name like 'CITY OF%' or group_name like 'DOUGLAS COUNTY%' or group_name like 'WASHOE COUNTY%')

;
update clone_lead
set
carrier_name = 'HOMETOWN HEALTH',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_570'
;
-- 'Rule 571 - Clone Express_Scripts 2XS%,4XS%,LXS%,XXS%,UXS000015660909,UXS000015660781'

insert into clone_lead
select *, 'RULE_571' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'CMS CONTRACT HEALTH INS P'
and coalesce(group_number, '') not in ('UXS000015660909','UXS000015660781')
and coalesce(group_number, '') not like '2XS%'
and coalesce(group_number, '') not like '4XS%'
and coalesce(group_number, '') not like 'LXS%'
and coalesce(group_number, '') not like 'XXS%'

;
update clone_lead
set
carrier_name = 'EMBLEM HEALTH',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_571'
;
-- 'Rule 572 - Clone Catamaran PURSYR'

insert into clone_lead
select *, 'RULE_572' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'PURSYR'

;
update clone_lead
set
carrier_name = 'EXCELLUS BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'SYRACUSE UNIVERSITY',
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_572'
;
-- 'Rule 573 - Clone Catamaran LCL1'

insert into clone_lead
select *, 'RULE_573' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'LCL1'

;
update clone_lead
set
carrier_name = 'EXCELLUS BCBS',
member_id = NULL,
group_number = '00044061',
group_name = 'UFCW LOCAL ONE HEALTH CARE FUND',
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_573'
;
-- 'Rule 574 - Clone Catamaran IUOE94 COMMERCIAL RETIRED COMMERCIAL RETIRED BASIC'

insert into clone_lead
select *, 'RULE_574' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOE94'
and coalesce(group_desc,'') not in ('COMMERCIAL RETIRED','COMMERCIAL RETIRED BASIC')

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_574'
;
-- 'Rule 575 - Clone Catamaran IUOEL15'

insert into clone_lead
select *, 'RULE_575' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOEL15'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = policy_id_alt,
group_number = NULL,
group_name = 'WELFARE FUND OF THE IUOE',
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_575'
;
-- 'Rule 576 - Clone Catamaran IUOE14 RETIREE%'

insert into clone_lead
select *, 'RULE_576' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOE14'
and coalesce(group_desc,'') not like 'RETIREE%'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLA' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_576'
;
-- 'Rule 577 - Clone Catamaran IUOE30'

insert into clone_lead
select *, 'RULE_577' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOE30'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLA' || policy_ssn,
group_number = NULL,
group_name = 'I.U.O.E. LOCAL 30',
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_577'
;
-- 'Rule 578 - Clone Catamaran IUOEPLHW MED'

insert into clone_lead
select *, 'RULE_578' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOEPLHW'
and coalesce(group_desc,'') <> 'MED'

;
update clone_lead
set
carrier_name = 'CAREFIRST BCBS',
member_id = 'CAA' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_578'
;
-- 'Rule 579 - Clone Catamaran BRM36BR MEC'

insert into clone_lead
select *, 'RULE_579' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'BRM36BR'
and group_name = 'MEC'

;
update clone_lead
set
carrier_name = 'BENEFIT AND RISK MANAGEMENT SERVICES (BRMS)',
member_id = left(member_id,9),
group_number = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_579'
;
-- 'Rule 580 - Clone Catamaran ACENSION PARRISH'

insert into clone_lead
select *, 'RULE_580' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'ACENSION PARRISH'

;
update clone_lead
set
carrier_name = 'BCBS LA',
member_id = 'XUP' || policy_id_alt,
group_number = '78J79ERC',
group_name = 'ASCENSION PARISH SCHOOL BOARD',
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_580'
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
member_id = 'JEA' || left(member_id, 9),
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
member_id = 'UFW' || left(member_id, 12),
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
-- 'Rule 583 - Clone Catamaran SCUFCW LCL455LA LCL455LB'

insert into clone_lead
select *, 'RULE_583' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'SCUFCW'
and subgroup_number in ('LCL455LA', 'LCL455LB')

;
update clone_lead
set
carrier_name = 'CIGNA',
member_id = left(member_id, 9),
group_number = '3338786',
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_583'
;
-- 'Rule 584 - Clone Catamaran FIVE RIVER CARPENTERS'

insert into clone_lead
select *, 'RULE_584' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'FIVE RIVER CARPENTERS'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_name = 'FIVE RIVERS CARPENTERS DIST',
group_number = '56794-0000',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_584'
;
-- 'Rule 585 - Clone OptumRx SHASTA ADMINISTRATIVE SVC'

insert into clone_lead
select *, 'RULE_585' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = 'SHASTA ADMINISTRATIVE SVC'

;
update clone_lead
set
carrier_name = 'SHASTA ADMINISTRATIVE SERVICES',
member_id = left(member_id, 9),
group_number = NULL,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_585'
;
-- 'Rule 586 - Clone CVS_Caremark INTERNATIONAL BEN ADMIN'

insert into clone_lead
select *, 'RULE_586' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'INTERNATIONAL BEN ADMIN'

;
update clone_lead
set
carrier_name = 'IBA TPA',
member_id = left(member_id, 11),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_586'
;
-- 'Rule 587 - Clone OptumRX PSI3552'

insert into clone_lead
select *, 'RULE_587' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and group_number = 'PSI3552'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLK' || policy_ssn,
group_number = '720100',
group_name = upper(carrier_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' THEN '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_587'
;
-- 'Rule 588 - Clone OptumRX ENNIS, INC.'

insert into clone_lead
select *, 'RULE_588' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = 'ENNIS, INC.'

;
update clone_lead
set
carrier_name = 'GROUP & PENSION ADMINISTRATORS (GPA)',
member_id = policy_id_alt,
group_number = 'H870451',
group_name = upper(medical_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_588'
;
-- 'Rule 589 - Clone OptumRX UNITED TEAMSTER FUND'

insert into clone_lead
select *, 'RULE_589' from cob_lead_staging
where carrier_name = 'OPTUMRX'
and medical_name = 'UNITED TEAMSTER FUND'

;
update clone_lead
set
carrier_name = 'MERITAIN',
member_id = NULL,
group_number = '16009',
group_name = 'UNITED TEAMSTER FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_589'
;
-- 'Rule 590 - Clone WelldyneRx SE POLK COMMUNITY SCHOOLS'

insert into clone_lead
select *, 'RULE_590' from cob_lead_staging
where carrier_name = 'WELLDYNERX'
and group_name = 'SE POLK COMMUNITY SCHOOLS'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = left(member_id, 11),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_590'
;
-- 'Rule 591 - Clone CVS_Caremark BOB EVANS RESTAURANTS'

insert into clone_lead
select *, 'RULE_591' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'BOB EVANS RESTAURANTS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = 'VRB' || policy_ssn,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_591'
;
-- 'Rule 592 - Clone Express_Scripts CT1839'

insert into clone_lead
select *, 'RULE_592' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'CT1839'

;
update clone_lead
set
carrier_name = 'ANTHEM BC CA',
member_id = 'UCR' || policy_ssn,
group_number = NULL,
group_name = 'CHEVRON CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_592'
;
-- 'Rule 593 - Clone Express_Scripts ONEALIN'

insert into clone_lead
select *, 'RULE_593' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'ONEALIN'

;
update clone_lead
set
carrier_name = 'BCBS AL',
group_number = NULL,
group_name = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_593'
;
-- 'Rule 594 - Clone Catamaran ONEALIN'

insert into clone_lead
select *, 'RULE_594' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'RWTPROVID'

;
update clone_lead
set
carrier_name = 'PROVIDENCE ADMINISTRATIVE SERVICES',
member_id = left(member_id, 10),
group_number = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_594'
;
-- 'Rule 595 - Clone MedImpact ONEALIN'

insert into clone_lead
select *, 'RULE_595' from cob_lead_staging
where carrier_name = 'MEDIMPACT'
and group_name = 'OCHSNER HEALTH NETWORK'

;
update clone_lead
set
carrier_name = 'BCBS LA',
member_id = 'OHI' || policy_ssn,
group_number = NULL,
pbm_person_code = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_595'
;
-- 'Rule 596 - Clone Express_Scripts RXBHEAD'

insert into clone_lead
select *, 'RULE_596' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXBHEAD'

;
update clone_lead
set
carrier_name = 'MERITAIN',
group_number = '15758',
group_name = 'HEAD INJURY ASSOCIATION INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_596'
;
-- 'Rule 597 - Clone Express_Scripts IBEW405'

insert into clone_lead
select *, 'RULE_597' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'IBEW405'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'CEDAR RAPIDS ELECTRICAL WORKER',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_597'
;
-- 'Rule 598 - Clone Express_Scripts HNICORP'

insert into clone_lead
select *, 'RULE_598' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'HNICORP'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'HNI CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_598'
;
-- 'Rule 599 - Clone Express_Scripts PELLARX'

insert into clone_lead
select *, 'RULE_599' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'PELLARX'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = 'VAN' || member_id,
group_number = '52588-PABS',
group_name = 'PELLA CORPORATION',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_599'
;
-- 'Rule 600 - Clone Express_Scripts RXBWELI'

insert into clone_lead
select *, 'RULE_600' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'RXBWELI'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'WEST LIBERTY FOODS LLC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_600'
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
member_id = 'NAT' || left(member_id, 9),
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
-- 'Rule 602 - Clone Express_Scripts BROOME9'

insert into clone_lead
select *, 'RULE_602' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BROOME9'

;
update clone_lead
set
carrier_name = 'EXCELLUS BCBS',
group_number = '00112665',
group_name = 'BROOME COUNTY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_602'
;
-- 'Rule 603 - Clone Express_Scripts WAWAINC'

insert into clone_lead
select *, 'RULE_603' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'WAWAINC'

;
update clone_lead
set
carrier_name = 'MERITAIN',
group_number = '16115',
group_name = 'WAWA INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_603'
;
-- 'Rule 604 - Clone Express_Scripts UMBPHBP'

insert into clone_lead
select *, 'RULE_604' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'UMBPHBP'

;
update clone_lead
set
carrier_name = 'MAGNACARE',
member_id = NULL,
group_number = '1021',
group_name = 'PENSION HOSP BENE PLAN OF ELEC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_604'
;
-- 'Rule 605 - Clone Express_Scripts UMBPHBP'

insert into clone_lead
select *, 'RULE_605' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LOCAL25'

;
update clone_lead
set
carrier_name = 'MAGNACARE',
member_id = NULL,
group_number = '2214',
group_name = 'I.B.E.W. LOCAL 25 H & B FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_605'
;
-- 'Rule 606 - Clone Express_Scripts 1181RX1'

insert into clone_lead
select *, 'RULE_606' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = '1181RX1'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLA' || policy_ssn,
group_number = NULL,
group_name = 'DIVISION 1181 A.T.U N Y WELFARE FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_606'
;
-- 'Rule 607 - Clone Express_Scripts NYDCC01'

insert into clone_lead
select *, 'RULE_607' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NYDCC01'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'NYB' || policy_ssn,
group_number = '82084',
group_name = 'NEW YORK DISTRICT COUNCIL OF CARPENTERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_607'
;
-- 'Rule 608 - Clone Express_Scripts LOCAL74'

insert into clone_lead
select *, 'RULE_608' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'LOCAL74'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'UES' || policy_ssn,
group_number = '720425',
group_name = 'U.S.W.U LOCAL 74 WELFARE FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_608'
;
-- 'Rule 609 - Clone Express_Scripts KMRA'

insert into clone_lead
select *, 'RULE_609' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'KMRA'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLK' || policy_ssn,
group_number = '720886',
group_name = 'RICHMOND UNIVERSITY MEDICAL CENTER',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_609'
;
-- 'Rule 610 - Clone Express_Scripts NYSTFRX'

insert into clone_lead
select *, 'RULE_610' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'NYSTFRX'

;
update clone_lead
set
carrier_name = 'EXCELLUS BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'NYS TEAMSTERS',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_610'
;
-- 'Rule 611 - Clone CVS_Caremark SW MINNEAPOLIS'

insert into clone_lead
select *, 'RULE_611' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'SW MINNEAPOLIS'

;
update clone_lead
set
carrier_name = 'MERITAIN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_611'
;
-- 'Rule 612 - Clone CVS_Caremark CATHOLIC HEALTH INIT. IA'

insert into clone_lead
select *, 'RULE_612' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'CATHOLIC HEALTH INIT.'
and member_state = 'IA'

;
update clone_lead
set
carrier_name = 'WELLMARK BCBS',
member_id = NULL,
group_number = NULL,
group_name = 'CATHOLIC HEALTH INITIATIVES',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_612'
;
-- 'Rule 613 - Clone Catamaran IHEART MEDIA BCBS'

insert into clone_lead
select *, 'RULE_613' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'IHEART MEDIA BCBS'

;
update clone_lead
set
carrier_name = 'BCBS IL (HCSC)',
member_id = left(member_id, 12),
group_number = NULL,
group_name = 'IHEART MEDIA INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_613'
;
-- 'Rule 614 - Clone Catamaran IHEART MEDIA'

insert into clone_lead
select *, 'RULE_614' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'IHEART MEDIA'

;
update clone_lead
set
carrier_name = 'MERITAIN',
member_id = left(member_id, 10),
group_number = '12888',
group_name = 'IHEART MEDIA INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_614'
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
member_id = 'WUC' || left(member_id, 8),
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
-- 'Rule 616 - Clone Express_Scripts H5LA'

insert into clone_lead
select *, 'RULE_616' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'H5LA'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'MSF' || policy_ssn,
group_number = '174769',
group_name = 'MEMORIAL SLOAN KETTERING CANCER CENTER',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_616'
;
-- 'Rule 617 - Clone CVS_Caremark H5LA'

insert into clone_lead
select *, 'RULE_617' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and (group_name like 'STATE OF MARYLAND%' or group_name in ('PRINCE GEORGES CTY PB SCH', 'LIFEBRIDGE HEALTH','FREDERICK CNTY PUBL SCH', 'MONTGOMERY CO PUB SCHOOLS'))

;
update clone_lead
set
carrier_name = 'CAREFIRST BCBS',
member_id = 'CAA' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_617'
;
-- 'Rule 618 - Clone CVS_Caremark PLUMBERS LOCAL UNION NO 1'

insert into clone_lead
select *, 'RULE_618' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'PLUMBERS LOCAL UNION NO 1'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'PLJ' || policy_ssn,
group_number = '377304',
group_name = 'PLUMBER INDUSTRY BOARD PLUMBERS LCL UNION NO 1',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_618'
;
-- 'Rule 619 - Clone CVS_Caremark IATSE'

insert into clone_lead
select *, 'RULE_619' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'IATSE'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'IAT' || policy_ssn,
group_number = '174549',
group_name = 'I.A.T.S.E NATIONAL BENEFIT FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_619'
;
-- 'Rule 620 - Clone CVS_Caremark AMRI'

insert into clone_lead
select *, 'RULE_620' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'AMRI'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'ZMR' || policy_ssn,
group_number = NULL,
group_name = 'ALBANY MOLECULAR RESEARCH, INC.',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_620'
;
-- 'Rule 621 - Clone CVS_Caremark APACHE IND'

insert into clone_lead
select *, 'RULE_621' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'APACHE IND'

;
update clone_lead
set
carrier_name = 'GROUP & PENSION ADMINISTRATORS (GPA)',
member_id = NULL,
group_number = 'H880017',
group_name = 'APACHE INDUSTRIAL SERVICES, INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_621'
;
-- 'Rule 622 - Clone CVS_Caremark WILBERT FUNERAL SERVICES'

insert into clone_lead
select *, 'RULE_622' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'WILBERT FUNERAL SERVICES'

;
update clone_lead
set
carrier_name = 'GROUP & PENSION ADMINISTRATORS (GPA)',
member_id = NULL,
group_number = 'H870825',
group_name = 'WILBERT INDUSTRIAL SERVICES, INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_622'
;
-- 'Rule 623 - Clone Catamaran UNITED CRAFTS BEN FUND'

insert into clone_lead
select *, 'RULE_623' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and policy_employer_name = 'UNITED CRAFTS BEN FUND'

;
update clone_lead
set
carrier_name = 'ANTHEM EMPIRE BCBS',
member_id = 'YLD' || policy_ssn,
group_number = '720717',
group_name = 'UNITED CRAFTS BENEFITS FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_623'
;
-- 'Rule 624 - Clone Express_Scripts EXLMDRX'

insert into clone_lead
select *, 'RULE_624' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EXLMDRX'
and coalesce(group_name,'') not like '%SIMPLY%' and coalesce(group_name,'') not like '%UNIVERA%'

;
update clone_lead
set
carrier_name = 'EXCELLUS BCBS',
member_id = 'VYM' || member_id,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%PM%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_624'
;
-- 'Rule 625 - Clone Express_Scripts EXLMDRX'

insert into clone_lead
select *, 'RULE_625' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'EXLMDRX'
and group_name like '%UNIVERA%'

;
update clone_lead
set
carrier_name = 'UNIVERA HEALTHCARE',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%PM%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_625'
;
-- 'Rule 626 - Clone Catamaran PCUSA'

insert into clone_lead
select *, 'RULE_626' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'PCUSA'
and coalesce(group_desc,'') not like '%AETNA%'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'YYP' || policy_ssn,
group_number = NULL,
group_name = 'BOARD OF PENSIONS OF THE PRESBYTERIAN CHURCH',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_626'
;
-- 'Rule 627 - Clone CVS_Caremark GEORGIA PACIFIC,MOLEX, GRAPHIC PACKAGING INC,WESTROCK COMPANY or INSPIRE BRANDS'

insert into clone_lead
select *, 'RULE_627' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name in ('GEORGIA PACIFIC', 'MOLEX', 'GRAPHIC PACKAGING INC', 'WESTROCK COMPANY', 'INSPIRE BRANDS')

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_627'
;
-- 'Rule 628 - Clone Catamaran IUOE825'

insert into clone_lead
select *, 'RULE_628' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOE825'

;
update clone_lead
set
carrier_name = 'BCBS NJ',
member_id = NULL,
group_number = NULL,
group_name = 'OPERATING ENGINEERS LOCAL 825',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_628'
;
-- 'Rule 629 - Clone Catamaran SONJCOM'

insert into clone_lead
select *, 'RULE_629' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'SONJCOM'
and coalesce(group_desc,'') not in ('AF10 LOCAL GOV', 'AHMO LOCAL ED', 'AHMO LOCAL GOV', 'AHMO ST MONTHLY', 'NJ LOCAL GOV FTA A', 'NJ LOCAL GOV FTA AF10')
and coalesce(group_desc,'') not like '%AETNA%'

;
update clone_lead
set
carrier_name = 'BCBS NJ',
member_id = 'NAT' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_629'
;
-- 'Rule 630 - Clone Express_Scripts FLOWERS'

insert into clone_lead
select *, 'RULE_630' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'FLOWERS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
member_id = left(member_id, 12),
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_630'
;
-- 'Rule 631 - Clone Express_Scripts SUNTRUST - AETNA PLANS'

insert into clone_lead
select *, 'RULE_631' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'SUNTRUST - AETNA PLANS'

;
update clone_lead
set
carrier_name = 'AETNA',
member_id = NULL,
group_number = NULL,
group_name = 'SUNTRUST BANKS INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_631'
;
-- 'Rule 632 - Clone Express_Scripts SUNTRUST - ANTHEM PLANS'

insert into clone_lead
select *, 'RULE_632' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and group_name = 'SUNTRUST - ANTHEM PLANS'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
member_id = 'FSU' || policy_ssn,
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_632'
;
-- 'Rule 633 - Clone Catamaran HMHS'

insert into clone_lead
select *, 'RULE_633' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'HMHS'

;
update clone_lead
set
carrier_name = 'BCBS NJ',
member_id = NULL,
group_number = NULL,
group_name = 'HACKENSACK MERIDIAN HEALTH',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_633'
;
-- 'Rule 634 - Clone Catamaran GOODYEAR'

insert into clone_lead
select *, 'RULE_634' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name = 'GOODYEAR'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS GA',
member_id = 'GYR' || policy_ssn,
group_number = NULL,
group_name = 'GOODYEAR TIRE & RUBBER COMPANY',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_634'
;
-- 'Rule 635 - Clone WelldyneRx EJGH'

insert into clone_lead
select *, 'RULE_635' from cob_lead_staging
where carrier_name = 'WELLDYNERX'
and group_name = 'EJGH'

;
update clone_lead
set
carrier_name = 'GILSBAR',
member_id = left(member_id, 10),
group_number = 'S2486',
group_name = 'EAST JEFFERSON GENERAL HOSPITAL',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_635'
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
member_id = case when left(policy_id,3) = 'QSJ' then 'QSJZ' || Right(policy_id,8)
when left(policy_id,3) = 'QSG' then 'QSGZ' || Right(policy_id,8)
else Right(policy_id,8) end,
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
-- 'Rule 637 - Clone Catamaran ANTHEM% L BRANDS INC'

insert into clone_lead
select *, 'RULE_637' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like 'ANTHEM%'
and policy_employer_name = 'STATE OF OHIO'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = NULL,
group_number = '004007521',
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_637'
;
-- 'Rule 638 - Clone Catamaran ANTHEM% UNIVERSITY OF NOTRE DAME'

insert into clone_lead
select *, 'RULE_638' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like 'ANTHEM%'
and policy_employer_name = 'UNIVERSITY OF NOTRE DAME'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS OH',
member_id = left(member_id, 12),
group_number = group_desc,
group_name = upper(policy_employer_name),
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_638'
;
-- 'Rule 639 - Clone Catamaran ANTHEM% KINDRED AT HOME'

insert into clone_lead
select *, 'RULE_639' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and group_name like 'ANTHEM%'
and policy_employer_name = 'KINDRED AT HOME'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS KY',
member_id = NULL,
group_number = NULL,
group_name = 'KINDRED AT HOME (GENTIVA)',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_639'
;
-- 'Rule 640 - Clone Catamaran KVATRX'

insert into clone_lead
select *, 'RULE_640' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'KVATRX'

;
update clone_lead
set
carrier_name = 'BCBS TN',
member_id = left(member_id, 12),
group_number = '125218',
group_name = 'K-VA-T FOOD STORES INC',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_640'
;
-- 'Rule 641 - Clone Express_Scripts BCBSMAN'

insert into clone_lead
select *, 'RULE_641' from cob_lead_staging
where carrier_name = 'EXPRESS_SCRIPTS'
and subgroup_number = 'BCBSMAN'
and member_id = policy_ssn

;
update clone_lead
set
carrier_name = 'AUTOMATED BENEFIT SERVICES',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%PM%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_641'
;
-- 'Rule 642 - Clone Catamaran AHA3890 AHA3890CL'

insert into clone_lead
select *, 'RULE_642' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name in ('AHA3890', 'AHA3890CL')

;
update clone_lead
set
carrier_name = 'INDEPENDENCE BLUE CROSS',
member_id = 'IKF' || member_id,
group_number = subgroup_number,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_642'
;
-- 'Rule 643 - Clone Catamaran AHA3870 AHA3870CL'

insert into clone_lead
select *, 'RULE_643' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name in ('AHA3870', 'AHA3870CL')

;
update clone_lead
set
carrier_name = 'AMERIHEALTH ADMINISTRATORS',
group_number = subgroup_number,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_643'
;
-- 'Rule 644 - Clone Catamaran AHA3890 AHA3890CL'

insert into clone_lead
select *, 'RULE_644' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'BLDHEALTH'

;
update clone_lead
set
carrier_name = 'BCBS TN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_644'
;
-- 'Rule 645 - Clone CVS_Caremark STATE OF FLORIDA HMO zips'

insert into clone_lead
select *, 'RULE_645' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'STATE OF FLORIDA HMO'
and member_zip in ('32430', '32424', '32421', '32399', '32360', '32352', '32351', '32344', '32343', '32333', '32332', '32327', '32326', '32324', '32321','32320', '32317', '32312', '32311', '32310', '32309', '32308', '32305', '32304', '32303', '32301', '32353', '32328', '32322', '32306', '32314', '32346', '32358', '32334', '32362')

;
update clone_lead
set
carrier_name = 'CAPITAL HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_645'
;
-- 'Rule 646 - Clone CVS_Caremark DEVOTED HEALTH H1290'

insert into clone_lead
select *, 'RULE_646' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'DEVOTED HEALTH H1290'

;
update clone_lead
set
carrier_name = 'DEVOTED HEALTH',
group_number = 'H1290',
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MC}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_646'
;
-- 'Rule 647 - Clone Catamaran VPSRX %Highmark%'

insert into clone_lead
select *, 'RULE_647' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'VPSRX'
and group_desc like '%Highmark%'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'YYM' || policy_ssn,
group_number = '01222701',
group_name = 'ST. CLAIR HOSPITAL',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_647'
;
-- 'Rule 648 - Clone Catamaran VPSRX %UPMC%'

insert into clone_lead
select *, 'RULE_648' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'VPSRX'
and group_desc like '%UPMC%'

;
update clone_lead
set
carrier_name = 'UPMC',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_648'
;
-- 'Rule 649 - Clone Catamaran VPSRX Multiple'

insert into clone_lead
select *, 'RULE_649' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'VPSRX'
and (group_desc in ('ACTIVE - CORE PLAN','ACTIVE - HDHP FAMILY','ACTIVE - HDHP INDIVIDUAL')
or group_desc like '%CORE%' or group_desc like '%BASIC%' or group_desc like '%PREMIER%')

;
update clone_lead
set
carrier_name = 'GILSBAR',
member_id = left(member_id, 10),
group_number = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_649'
;
-- 'Rule 650 - Clone CIGNA (GREAT WEST) MM Multiple'

insert into clone_lead
select *, 'RULE_650' from cob_lead_staging
where carrier_name = 'CIGNA (GREAT WEST)'
and plan_type = '{MM}'
and group_number not in ('00052665', '00005241', '00703020', '00605103')

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
member_id = NULL,
group_number = NULL,
pbm_bin  = '017010',
pbm_pcn  = '05180',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_650'
;
-- 'Rule 651 - Clone BENESYS VPSRX Multiple'

insert into clone_lead
select *, 'RULE_651' from cob_lead_staging
where carrier_name = 'BENESYS'
and group_number in ('162KAISER', 'D10KAISER', 'D20KAISER', 'L10KAISER', 'L20KAISER', 'L80KAISER', 'P30KAISER', 'P40KAISER', 'P70KAISER', 'PJ0KAISER', 'PL0KAISER', 'Q40KAISER', 'Q90KAISER', 'S10KAISER', 'S20KAISER', 'S30KAISER', 'S60KAISER')

;
update clone_lead
set
carrier_name = 'KAISER FOUNDATION HEALTH PLAN',
member_id = NULL,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_651'
;
-- 'Rule 652 - Clone Catamaran VPSRX'

insert into clone_lead
select *, 'RULE_652' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'VPSRX'
and (group_desc like 'UPM FL%' or group_desc like 'UPM OOF%' or group_desc like 'UPM COBRA%' or group_desc like '%UWH%')

;
update clone_lead
set
carrier_name = 'BCBS SC',
member_id = 'UNW' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_652'
;
-- 'Rule 653 - Clone CVS_Caremark CCOK%'

insert into clone_lead
select *, 'RULE_653' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name like 'CCOK%'

;
update clone_lead
set
carrier_name = 'COMMUNITY CARE OF OKLAHOMA',
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_653'
;
-- 'Rule 654 - Clone CVS_Caremark HEALTHTRUST'

insert into clone_lead
select *, 'RULE_654' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'HEALTHTRUST'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS NH',
member_id = 'EHH' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_654'
;
-- 'Rule 655 - Clone CVS_Caremark UTC CDH ANTHEM'

insert into clone_lead
select *, 'RULE_655' from cob_lead_staging
where carrier_name = 'CVS_CAREMARK'
and group_name = 'UTC CDH ANTHEM'

;
update clone_lead
set
carrier_name = 'ANTHEM BCBS CT',
member_id = 'UQK' || policy_ssn,
group_number = NULL,
group_name = NULL,
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_655'
;
-- 'Rule 656 - Clone TPL_CIGNA_EMV Huge list'

insert into clone_lead
select *, 'RULE_656' from cob_lead_staging
where Submitter = 'TPL_CIGNA_EMV'
and ((subgroup_number = 'OAP1'
and group_name in ('3 TWENTY-THREE PERSONNEL,',
'ABRA AUTO BODY & GLASS',
'ACCOR MANAGEMENT US INC.',
'ADVANSIX INC.',
'AECOM',
'ALDI INC.',
'ALEXION PHARMACEUTICALS,',
'ALLIED BUILDING PRODUCTS',
'ALLSCRIPTS HEALTHCARE SOL',
'ALTRIA CLIENT SERVICES LL',
'AMDOCS, INC.',
'AMERICAN CENTURY SERVICES',
'AMERICAN MULTI-CINEMA, IN',
'AMERICAN RENAL MANAGEMENT',
'ARCADIS U.S., INC.',
'ARCOSA, INC.',
'ARIZONA PIPE TRADE HEALTH',
'ARLINGTON COUNTY SCHOOL B',
'ARS ACQUISITION HOLDINGS,',
'ASML US, LLC',
'ASSOCIATED WHOLESALE GROC',
'AUDATEX HOLDINGS, INC.',
'AXA EQUITABLE FINANCIAL S',
'BALL CORPORATION',
'BALTIMORE COUNTY PUBLIC S',
'BARRY-WEHMILLER COMPANIES',
'BEACON HEALTH OPTIONS',
'BEACON SALES ACQUISITION,',
'BIG Y FOODS, INC.',
'BMW OF NORTH AMERICA, LLC',
'BORAL INDUSTRIES INC.',
'BORGWARNER INC.',
'BREVARD COUNTY BOCC, FL',
'C.H. GUENTHER & SON, LLC',
'CAE USA',
'CANCER TREATMENT CENTERS',
'CARDINAL LOGISTICS MANAGE',
'CARECENTRIX, INC.',
'CAREMOUNT MEDICAL, P.C.',
'CATHOLIC DIOCESE OF ARLIN',
'CELGENE CORPORATION',
'CGI TECHNOLOGIES AND SOLU',
'CHOICE HOTELS INTERNATION',
'CIGNA COMPANIES',
'CINCINNATI FINANCIAL CORP',
'CIOX HEALTH, LLC',
'CITRIX SYSTEMS, INC.',
'CITY OF CLEARWATER',
'CITY OF HOLLYWOOD, FL',
'CITY OF HOUSTON',
'CITY OF INDEPENDENCE, MIS',
'CITY OF MCKINNEY',
'CITY OF OLATHE, KANSAS',
'CITY OF RICHMOND',
'CITY OF STAMFORD',
'CITY OF TUCSON',
'CLP HEALTHCARE SERVICES,',
'COLORADO SPRINGS UTILITIE',
'COMPUTER SCIENCES CORPORA',
'COVENANT TRANSPORT, INC.',
'CROSS COUNTRY HEALTHCARE,',
'D.R. HORTON, INC.',
'DAL GLOBAL SERVICES, LLC',
'DARLING INGREDIENTS INC.',
'DAVITA KIDNEY CARE',
'DOCUMENT TECHNOLOGIES LLC',
'DPR CONSTRUCTION',
'DSV AIR & SEA INC.',
'DYNCORP INTERNATIONAL, LL',
'ECHOSTAR CORPORATION',
'ELECTRONIC ARTS INC.',
'EMPLOYBRIDGE HOLDING COMP',
'ENTEGRIS, INC.',
'EPAM SYSTEMS, INC.',
'EQUIFAX INC.',
'ESTES EXPRESS LINES',
'EVERGY, INC.',
'EVERGY, INC./WESTAR ENERG',
'FAIRFAX COUNTY GOVERNMENT',
'FIREEYE, INC.',
'FIRSTCASH, INC.',
'FLOYD HEALTHCARE MANAGEME',
'FORMOSA PLASTICS CORPORAT',
'FORWARD AIR CORPORATION,',
'FOSSIL GROUP, INC.',
'FOUR SEASONS DBA VEBA',
'FUJIFILM HOLDINGS AMERICA',
'GARTNER, INC.',
'GENERAL DYNAMICS- BIW',
'GENERAL MOTORS FINANCIAL',
'GENWORTH NORTH AMERICA CO',
'GREAT HEARTS ACADEMIES',
'GROUP 1 AUTOMOTIVE',
'H&M HENNES & MAURITZ L.P.',
'HALLMARK CARDS INCORPORAT',
'HAMILTON COUNTY GOVERNMEN',
'HAMPTON CITY SCHOOLS',
'HANESBRANDS INC.',
'HARRIS COUNTY AND HARRIS',
'HARRIS TEETER, LLC',
'HARSCO CORPORATION',
'HELENA AGRI-ENTERPRISES,',
'HENSEL PHELPS CONSTRUCTIO',
'HERAEUS INCORPORATED',
'HILLSBOROUGH COUNTY BOARD',
'HILTON DOMESTIC OPERATING',
'HONEYWELL INTERNATIONAL I',
'HOUGHTON MIFFLIN HARCOURT',
'HUNTING ENERGY SERVICES,',
'IDEMIA IDENTITY & SECURIT',
'INTEPLAST GROUP CORPORATI',
'INTERACTIVE COMMUNICATION',
'INTERIOR LOGIC GROUP, INC',
'JETRO HOLDINGS, LLC',
'JTEKT NORTH AMERICA CORPO',
'JUNIPER NETWORKS, INC.',
'K12 SERVICES',
'KENCO',
'KLOECKNER METALS CORPORAT',
'KONICA MINOLTA BUSINESS S',
'KUEHNE || NAGEL INC.',
'LANE INDUSTRIES INC.',
'LARSEN & TOUBRO INFOTECH',
'LEE COUNTY SHERIFF''S OFFI',
'LEGRAND NORTH AMERICA',
'LINCOLN PROPERTY COMPANY',
'LINCOLN PROPERTY E.C.W.,',
'M. A. MORTENSON COMPANY',
'MAGIC LEAP INC. AND SUBSI',
'MARTA',
'MCCARTHY HOLDINGS, INC.',
'MCGUIREWOODS LLP',
'MDC HOLDINGS, INC.',
'MECKLENBURG COUNTY',
'MESA UNIFIED SCHOOL DISTR',
'METROPOLITAN GOVERNMENT O',
'METROPOLITAN NASHVILLE PU',
'MIAMI-DADE COUNTY PUBLIC',
'MIDWEST PUBLIC RISK OF MI',
'MINDTREE LIMITED',
'MISSOURI EDUCATORS UNIFIE',
'MORGAN AND MORGAN, P.A.',
'MOVEMENT MORTGAGE, LLC',
'MPHASIS CORPORATION',
'NATIONAL INSTRUMENTS CORP',
'NETFLIX, INC.',
'NEW LIFECARE MANAGEMENT S',
'NTHRIVE, INC.',
'OPPENHEIMER & CO. INC.',
'ORANGE COUNTY BOCC',
'ORANGE COUNTY SHERIFF''S O',
'O''REILLY AUTOMOTIVE, INC.',
'PACIFIC ARCHITECTS AND EN',
'PARTY CITY HOLDINGS, INC.',
'PCC STRUCTURALS, INC.',
'PEGASYSTEMS INC.',
'PEOPLE''S UNITED BANK, N.A',
'PINNACLE PROPERTY MANAGEM',
'PIPE INDUSTRY HEALTH & WE',
'POINT72, L.P.',
'PREMIER, INC',
'PRESIDIO LLC',
'PRIVATE NATIONAL MORTGAGE',
'PRO UNLIMITED GLOBAL SOLU',
'PTC INC.',
'PURE STORAGE, INC',
'PYRAMID HOTEL GROUP',
'RACETRAC PETROLEUM, INC.',
'RANGER ENERGY SERVICES, L',
'RC WILLEY HOME FURNISHING',
'REGAL CINEMAS',
'RESIDEO TECHNOLOGIES, INC',
'RGA REINSURANCE COMPANY',
'RICHMOND PUBLIC SCHOOLS',
'RUTHERFORD COUNTY EMPLOYE',
'S&B ENGINEERS AND CONSTRU',
'SAINT-GOBAIN CORPORATION',
'SASOL (USA) CORPORATION',
'SCHINDLER ELEVATOR CORPOR',
'SCHLUMBERGER',
'SCHOTTENSTEIN STORES CORP',
'SCL HEALTH',
'SELF-INSURANCE POOL OF GR',
'SENTARA HEALTHCARE MEDICA',
'SGT, INC.',
'SHELBY COUNTY SCHOOLS',
'SIERRA NEVADA CORPORATION',
'SIMON PROPERTY GROUP',
'SKY CHEFS, INC.',
'SLALOM LLC',
'SMITH & NEPHEW, INC.',
'SS&C TECHNOLOGIES, INC.',
'ST. LOUIS COMMUNITY COLLE',
'STANLEY BLACK & DECKER, I',
'STAR GROUP, L.P.',
'STARBUCKS CORPORATION',
'STV GROUP, INC.',
'SUMITOMO MITSUI BANKING C',
'SUNSTATE EQUIPMENT COMPAN',
'TAYLOR MORRISON, INC.',
'TEXAS ROADHOUSE MANAGEMEN',
'THE CORPS NETWORK',
'THE COUNTY SCHOOL BOARD O',
'THE FRESH MARKET, INC.',
'THE MIDDLEBY CORPORATION',
'THE QUIKRETE COMPANIES, I',
'THE REYNOLDS AND REYNOLDS',
'THE SCHOOL BOARD OF BREVA',
'THE SUNDT COMPANIES, INC.',
'THE WESTERN UNION COMPANY',
'TOKYO ELECTRON U.S. HOLDI',
'TOWNEBANK',
'TRINITY INDUSTRIES, INC.',
'TTM TECHNOLOGIES, INC.',
'TWITTER, INC.',
'ULINE, INC',
'UMB FINANCIAL CORPORATION',
'UNIVERSITY OF MAINE SYSTE',
'UNIVERSITY OF RICHMOND',
'VIRGINIA PREMIER HEALTH P',
'VIRTUSA CORPORATION',
'VISA INC.',
'VISION SERVICE PLAN',
'VOLUSIA COUNTY GOVERNMENT',
'WASHINGTON COUNTY PUBLIC',
'WASTE MANAGEMENT HOLDINGS',
'WATTS WATER TECHNOLOGIES,',
'WEBSTER BANK, N.A.',
'WESTERN GOVERNORS UNIVERS',
'WILLIAMSON COUNTY GOVERNM',
'WORKDAY, INC.',
'WYNDHAM DESTINATIONS',
'ZAYO GROUP, LLC',
'ZIONS BANCORPORATION',
'ZOVIO'))
or (subgroup_number = 'OAPIN'
and group_name in ('AUSTIN INDUSTRIES, INC.',
'BALTIMORE COUNTY PUBLIC S',
'BALTIMORE COUNTY, MARYLAN',
'CHARTER SCHOOLS USA, INC',
'CHENEY BROTHERS, INC.',
'CITRIX SYSTEMS, INC.',
'CITY OF HOUSTON',
'CITY OF SCOTTSDALE',
'EXXONMOBIL',
'FREDERICK COUNTY GOVERNME',
'GENERAL DYNAMICS- BIW',
'HUNTER DOUGLAS INC.',
'IBEW LOCAL 613',
'LANDRY''S, LLC',
'MILLER MC, INC., DBA, LAR',
'O''REILLY AUTOMOTIVE, INC.',
'SCA EMPLOYEES OF MAXIMUS',
'SHELBY COUNTY GOVERNMENT',
'SHELBY COUNTY SCHOOLS',
'WASTE MANAGEMENT HOLDINGS',
'WYNDHAM DESTINATIONS'))
or (subgroup_number = 'OAP1R'
and group_name in ('CIGNA COMPANIES',
'DAVITA KIDNEY CARE',
'HILTON DOMESTIC OPERATING',
'MIAMI-DADE COUNTY PUBLIC',
'STARBUCKS CORPORATION'))
or (subgroup_number = 'EPP1'
and group_name in ('CHILDREN''S HEALTHCARE OF',
'CITY OF HOUSTON',
'CITY OF TUCSON',
'HOAG MEMORIAL HOSPITAL PR',
'MARICOPA COUNTY',
'PALM BEACH COUNTY SHERIFF'))
or (subgroup_number = 'PPO1'
and group_name in ('EMBASSY OF THE STATE OF K',
'NFL PLAYER INSURANCE PLAN',
'PLUMpbm_bin G & PIPEFITTING IN',
'THE UNIVERSITY OF OKLAHOM'))
or (subgroup_number = 'OAP1NR'
and group_name in ('SCHOOL DISTRICT OF OSCEOL',
'UNIVERSAL ORLANDO',
'WILLIAMSON COUNTY GOVERNM'))
or (subgroup_number = 'HMO1'
and group_name in ('COUNTY OF ORANGE',
'RADY CHILDREN''S HOSPITAL-'))
or (subgroup_number = 'BASEMM'
and group_name in ('BALTIMORE COUNTY PUBLIC S',
'BALTIMORE COUNTY, MARYLAN'))
or (subgroup_number = 'DPP1'
and group_name in ('PALM BEACH COUNTY SHERIFF',
'VISA INC.'))
or (subgroup_number = 'DPP4'
and group_name in ('CITY OF MIAMI',
'IAFF LOCAL 587 HEALTH INS'))
or (subgroup_number = 'EPP4'
and group_name in ('HAMILTON COUNTY DEPARTMEN',
'ROBSON COMMUNITIES, INC.'))
or (subgroup_number = 'CHA4'
and group_name in ('CITY OF SOUTHAVEN, MS',
'UT GRADUATE MEDICAL EDUCA'))
or (subgroup_number = 'HMO4'))

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
pbm_bin  = '017010',
pbm_pcn  = '05180',
plan_type = '{PA}'
where match_carrier_rule_id_extra = 'RULE_656'
;
-- 'Rule 657 - Clone TPL_CIGNA_EP List'

insert into clone_lead
select *, 'RULE_657' from cob_lead_staging
where Submitter = 'TPL_CIGNA_EP'
and group_name in ('AMITA HEALTH ALEXIAN BROT',
'ASCENSION',
'ASCENSION HEALTH INFORMAT',
'ASCENSION LIVING',
'ASCENSION MEDICAL RESOURC',
'ASCENSION SYSTEM OFFICE',
'BORGESS HEALTH, KALAMAZOO',
'COLUMBIA ST. MARY''S , MIL',
'CRITTENTON HSP MED CTR, R',
'DAUGHTERS OF CHARITY MINI',
'DAUGHTERS OF CHARITY, SAN',
'GENESYS HEALTH SYSTEMS, G',
'MEDXCEL FACILITY MANAGEME',
'MINISTRY HEALTH',
'MINISTRY SERVICE CENTER',
'OUR LADY OF LOURDES, pbm_bin G',
'PROVIDENCE HEALTHCARE NET',
'PROVIDENCE HOSPITAL MOBIL',
'PROVIDENCE HOSPITAL, WASH',
'SETON FAMILY OF HOSPITALS',
'ST. AGNES HEALTHCARE',
'ST. JOHN PROVIDENCE HEALT',
'ST. JOSEPH''S HEALTH SYSTE',
'ST. MARY''S HEALTH SYSTEM,',
'ST. MARY''S HEALTHCARE, AM',
'ST. MARY''S OF MICHIGAN, S',
'ST. THOMAS HEALTH SERVICE',
'ST. VINCENT HEALTH, INDIA',
'ST. VINCENT''S HEALTH SERV',
'ST. VINCENT''S HEALTH SYST',
'VIA CHRISTI, WICHITA, KS')

;
update clone_lead
set
carrier_name = 'DST HEALTH SOLUTIONS (ARGUS)',
pbm_bin  = '017010',
pbm_pcn  = '05180',
plan_type = case
when plan_type::text like '%PY%' then '{PA}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_657'
;
-- 'Rule 658 - Clone Catamaran IUOE66'

insert into clone_lead
select *, 'RULE_658' from cob_lead_staging
where carrier_name = 'CATAMARAN'
and medical_name = 'IUOE66'

;
update clone_lead
set
carrier_name = 'HIGHMARK BCBS',
member_id = 'YYM' || policy_ssn,
group_number = '01337800',
group_name = 'OPERATING ENGINEERS LOCAL #66 WELFARE FUND',
pbm_bin  = NULL,
pbm_pcn  = NULL,
pbm_person_code = NULL,
plan_type = case
when plan_type::text like '%PA%' then '{MM}'
when plan_type::text like '%MD%' then '{MC}'
else plan_type end
where match_carrier_rule_id_extra = 'RULE_658'
;