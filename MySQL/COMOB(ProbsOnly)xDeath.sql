with ethcomorbmort as (with base_data as (with comorb as (select admid, problem, prob_name from probs 
#union 
#select admid, problem, med_hx_name prob_name from medhx
) 
select 
distinct
adm.admid,
adm.PATIENTID as PATIENTID,
adm.DISCH_DEST, 
resp.group_name as RESP_GROUP_NAME,
resp.prob_name as RESP_CONDITION_NAME, 
probs.prob_name as CONDITION_NAME, 
comorb.prob_name as COMORB_NAME, 
demog.ethnicity as ETHNICITY,
adm.ADM_DATE,
adm.DIS_DATE,
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
select distinct admid, Ethnicity, Comorbidities,   Mortality  from 
(select admid, case when ETHNICITY ='' then 'Z' else ETHNICITY end ETHNICITY, condition_name, sum(case when COMORB_NAME is null then 0 else 1 end) Comorbidities, case when DISCH_DEST = 79 then 1 else 0 end Mortality from base_data
 group by admid,ETHNICITY, condition_name, DISCH_DEST, ITU_START_DATE, ITU_START_TIME, ITU_END_DATE, ITU_END_TIME) y)
 select   * from ethcomorbmort ;
-- select    Comorbidities, sum(mortality)/count(1) Probability_Mortality from ethcomorbmort group by  Comorbidities;
 
 