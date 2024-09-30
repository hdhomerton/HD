with base_data as (with comorb as (select admid, problem, prob_name from probs 
#union 
#select admid, problem, med_hx_name prob_name from medhx
) 
select 
distinct
adm.admid,
adm.PATIENTID as PATIENTID,
adm.DISCH_DEST,
probs.problem as CONDITION_ID,
resp.group_name as RESP_GROUP_NAME,
resp.prob_name as RESP_CONDITION_NAME, 
probs.prob_name as CONDITION_NAME, 
comorb.prob_name as COMORB_NAME, 
demog.ethnicity as ETHNICITY,
demog.gender as GENDER,
adm.ADM_DATE,
adm.DIS_DATE,
adm.AGE_GRP_AT_ADM as ADM_AGEG,
adm.AGE_GRP_AT_DIS as DIS_AGEG,
itu.start_date as ITU_START_DATE,
itu.start_time as ITU_START_TIME,
itu.end_date as ITU_END_DATE,
itu.end_time as ITU_END_TIME, 
itu.end_date  - itu.start_date  LOS
from adm
left outer join demog on (adm.patientid = demog.patientid)
inner join itu on (adm.ADMID = itu.admid)
inner join probs on (itu.ADMID = probs.admid)
inner join resp on (probs.problem = resp.problem)
left outer join comorb on (comorb.ADMID = probs.admid and comorb.problem <> probs.problem and comorb.prob_NAME <> probs.prob_NAME)
order by adm.PATIENTID, condition_name, itu.START_DATE, itu.START_TIME)
select distinct patientid, probs.problem from base_data where problem = '19829001';

(select * from base_data);

select gender, count(1) npatient from
(select distinct gender, patientid  from base_data) x group by gender;


select * from base_data where patientid = '0D5F4891345CF79CA2A17759C491C76AEDE3296763851DFCB32C59DF51D47309';

select resp_group_name , count(1) npatients from
(select distinct patientid, resp_group_name  from base_data) x group by resp_group_name;


select * from probs where problem = '19829001';



select admid, PATIENTID, DISCH_DEST, CONDITION_ID, 
RESP_GROUP_NAME, RESP_CONDITION_NAME,   CONDITION_NAME, 
 COMORB_NAME,   ITU_START_DATE,
 ITU_START_TIME,ITU_END_DATE, ITU_END_TIME, LOS, count(1) c  from base_data 
 
 where admid = 'A057F7712B04051FD6DFB5D68B0D70F6A119CC52A76CFE13506C795D0148F276'
 group by 
admid, PATIENTID, DISCH_DEST, CONDITION_ID, 
RESP_GROUP_NAME, RESP_CONDITION_NAME,   CONDITION_NAME, 
 COMORB_NAME,  ITU_START_DATE,
 ITU_START_TIME,ITU_END_DATE, ITU_END_TIME;

select * from probs, resp where probs.problem = resp.problem and admid = '43008732710BEDC0C3D6E9F8BB69402E52E9B00FC5D59EC295A76FA788B725FD';

select * from
(select probs.admid, count(1) c from probs, resp, probs cm  where
 probs.problem = resp.problem and cm.admid = probs.admid and cm.problem <> probs.problem  group by admid) x where c > 1;