with icu_readmission as (
SELECT PATIENTID, admid, CASE WHEN CNT = MAX_CNT THEN 0 ELSE 1 END L_ADMISSION, DISCH_DEST from
(select PATIENTID, admid, cnt, max(cnt) over (partition by PATIENTID) max_cnt , DISCH_DEST from 
(select adm.PATIENTID, adm.admid, count(1) over (partition by PATIENTID order by ADM_DATE, ADM_TIME) cnt , adm.DISCH_DEST from  adm
where admid in (select distinct admid from itu)) x)y
)
select * from icu_readmission;


select PATIENTID, admid,  start_date, START_TIME, end_date, end_TIME,DISCH_DEST, case when ituid = max then 0 else 1 end l_admission from 
(select adm.PATIENTID, adm.admid,  itu.start_date, itu.START_TIME, itu.end_date, itu.end_TIME, 
        count(1) over (partition by PATIENTID order by ADM_DATE, ADM_TIME,  itu.start_date, itu.START_TIME) ituid,  count(1) over (partition by PATIENTID) max, adm.DISCH_DEST from  adm
 inner join itu on (adm.admid = itu.admid)) x;

select  ADMID, start_date, start_time, end_date, end_time, count(1) over (partition by ADMID order by start_date, START_TIME) itu_visit from itu
order by admid, start_date, START_TIME;

(select admid, problem, prob_name from probs 
#union 
#select admid, problem, med_hx_name prob_name from medhx
);

select * from itu;
select * from probs;