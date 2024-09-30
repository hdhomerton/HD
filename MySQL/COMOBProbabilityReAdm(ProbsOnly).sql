with ethcomorbreadmit as (with base_data as (with comorb as (select admid, problem, prob_name from probs 
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
left outer join comorb on (comorb.ADMID = probs.admid and comorb.problem <> probs.problem AND comorb.prob_NAME <> probs.prob_NAME )
order by adm.PATIENTID, condition_name, itu.START_DATE, itu.START_TIME),
itu_readmission as (select PATIENTID, admid,  start_date, START_TIME, end_date, end_TIME,DISCH_DEST, case when ituid = max then 0 else 1 end l_readmission from 
(select adm.PATIENTID, adm.admid,  itu.start_date, itu.START_TIME, itu.end_date, itu.end_TIME, 
        count(1) over (partition by PATIENTID order by ADM_DATE, ADM_TIME,  itu.start_date, itu.START_TIME) ituid,  count(1) over (partition by PATIENTID) max, adm.DISCH_DEST from  adm
 inner join itu on (adm.admid = itu.admid)) x)
select distinct b.admid, Ethnicity, merged_comorb_name , L_Readmission as "L_Readmission",b.DISCH_DEST, itu_start_date, itu_start_time, itu_end_date, itu_end_time   from 
(select admid, case when Ethnicity ='' then 'Z' else Ethnicity end Ethnicity, DISCH_DEST, 
         condition_name, merged_comorb_name , los, itu_start_date, itu_start_time, itu_end_date, itu_end_time   from 
         (select *, case 
    when lower(comorb_name)  like '%kidney injury%' then 'Acute kidney injury' 
    when lower(comorb_name) like '%sepsis%' or comorb_name in ('Septic shock')  then 'Sepsis' 
    when lower(comorb_name) like '%atrial fibrillation%' then 'Atrial fibrillation'
    when lower(comorb_name) like '%covid%' then  'COVID'
    when lower(comorb_name) like '%obesity%' then  'Obesity'
	when lower(comorb_name) like '%pulmonary embo%' then  'Pulmonary embolism'
    when lower(comorb_name) like '%anaemia%' then  'Anaemia'
    when lower(comorb_name) like '%delirium%' then  'Delirium'
    when lower(comorb_name) like '%diabetes%' then  'Diabetes'
    when lower(comorb_name) like '%copd%' then  'COPD'
    when lower(comorb_name) like '%asthma%' then  'Asthma'
    when lower(comorb_name) like '%neumonia%' then  'Pneumonia'
    when lower(comorb_name) like '%respiratory failure%' then 'Respiratory failure' else comorb_name end 
    merged_comorb_name from base_data) z
 group by admid,Ethnicity, DISCH_DEST,  condition_name, merged_comorb_name, los, itu_start_date, itu_start_time, itu_end_date, itu_end_time) b
 inner join itu_readmission r on (r.ADMID = b.admid and r.start_date = b.itu_start_date 
 and r.start_time = b.itu_start_time and r.end_date = b.itu_end_date and r.end_time = b.itu_end_time)
where not(l_readmission = 0 and b.disch_dest=79) 
order by b.admid, l_readmission desc)  
select    merged_comorb_name , sum(l_readmission)/count(1) Probability_Readmission from ethcomorbreadmit 
where merged_comorb_name in  ('Sepsis','Kidney injury(Acute)','Pneumonia','Respiratory failure',
'Atrial fibrillation','Hypertension','Obesity','Delirium','Diabetes','Anaemia','COVID','Pulmonary embolism','COPD','Asthma','Hyponatraemia') 
group by  merged_comorb_name ;
#select  admid, merged_comorb_name , l_readmission from ethcomorbreadmit ;
 