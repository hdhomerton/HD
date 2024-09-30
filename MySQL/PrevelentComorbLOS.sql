with base_data as (with comorb as (select admid, problem, prob_name from probs 
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
select admid, merged_comorb_name, sum(los) los from (select distinct admid, case 
    when lower(comorb_name)  like '%kidney injury%' then 'Kidney injury(Acute)'
    when lower(comorb_name) like '%sepsis%' or comorb_name in ('Septic shock')  then 'Sepsis' 
    when lower(comorb_name) like '%atrial fibrillation%' then 'Atrial fibrillation'
    when lower(comorb_name) like '%covid%' and lower(comorb_name) not like '%sus%' then  'COVID'
    when lower(comorb_name) like '%obesity%' then  'Obesity'
	when lower(comorb_name) like '%pulmonary embo%' then  'Pulmonary embolism'
    when lower(comorb_name) like '%anaemia%' then  'Anaemia'
    when lower(comorb_name) like '%delirium%' then  'Delirium'
    when lower(comorb_name) like '%diabetes%' then  'Diabetes'
    when lower(comorb_name) like '%copd%' then  'COPD'
    when lower(comorb_name) like '%asthma%' then  'Asthma'
    when lower(comorb_name) like '%neumonia%' then  'Pneumonia'
    when lower(comorb_name) like '%respiratory failure%' then 'Respiratory failure' else comorb_name end 
    merged_comorb_name, los,itu_START_DATE, itu_START_TIME from base_data ) x
where merged_comorb_name in  ('Sepsis','Kidney injury(Acute)','Pneumonia','Respiratory failure',
'Atrial fibrillation','Hypertension','Obesity','Delirium','Diabetes','Anaemia','COVID','Pulmonary embolism','COPD','Asthma','Hyponatraemia') 
group by admid, merged_comorb_name;  
 
 