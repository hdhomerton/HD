select distinct probs.problem,resp.problem resp_problem,  probs.PROB_NAME, resp.prob_name resp_prob_name, resp.group_name, resp.group_id from 
(select problem, count(1) num from
(select distinct probs.problem, probs.PROB_NAME from probs where 
  problem in (select problem from resp)
) dprob
group by problem ) cprob, probs, resp where cprob.problem = probs.problem and resp.problem = probs.problem and num > 1 
order by probs.PROBLEM;
 
select * from resp where problem = 491000119101;
#Probable deletion
#161512007