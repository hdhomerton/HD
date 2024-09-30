select count(1) from (select distinct admid from adm) x;

select distinct admid, PATIENTID, ADM_DATE, DIS_DATE, adm_time, dis_time from adm
order by adm_date, adm_time;

select * from probs where PROBLEM = 1003722009;



select distinct probs.problem, probs.PROB_NAME from 
(select problem, count(1) num from
(select distinct probs.problem, probs.PROB_NAME from probs where 
  problem in (select problem from resp)
) dprob
group by problem ) cprob, probs where cprob.problem = probs.problem and num > 1 
order by PROBLEM;

select distinct probs.problem, probs.PROB_NAME from probs where problem = 19585003;
select * from resp where problem = 19585003;
delete from resp where problem  = 419991009;
select * from resp;
delete from resp  where problem = 429091008;
alter table cuhdb.resp add column group_id int;
alter table cuhdb.resp add column group_name varchar(1000);
commit;
select distinct probs.problem, probs.PROB_NAME from probs where 
  prob_name in (select prob_name from resp);


insert into resp (problem, prob_name) values (27624003,'Chronic pulmonary aspiration');

insert into resp (problem, prob_name) values (27624003,'Chronic interstitial lung disease');

select distinct nat_adm_meth from adm;



update resp
set prob_name = 'Community acquired pneumonia'
where problem = 301001009;
delete from resp  where problem = 49727002;

update resp
set group_name = 'Pneumonia'
where problem = 429271009;

update resp
set group_name = 'Sleep apnoea'
where problem = 78275009; 
commit;

select * from resp where problem = 27624003;
select * from probs where problem = 50417007;

delete from resp  where problem = 94225005;