Select Distinct

u.username,
ci.enrollment_datetime,
ci.completion_datetime,
ci.course_name_at_time_of_enrollment,
o.external_org_id as AO_Key,
o.org_name,
inst.org_node_name as Institution,
dept.org_node_name as Department,
ci.course_id,
ci.course_instance_id,
ci.course_instance_interaction_mode_id,
ci.estimated_completion_seconds,
cis.description as course_instance_status,
us.user_student_id,
inst.org_node_id as Institution_ID,
dept.org_node_code as Dept_ID



from
dbo.org o with (nolock)

inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0

inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id  	and ci.is_deleted in (0,1)

inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id

inner join dbo.course_category_course_mapping cccm with (nolock)
on ci.course_id = cccm.course_id

inner join dbo.course_category cc with (nolock)
on cccm.course_category_id = cc.course_category_id

inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id

inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0

inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0


where o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date  -- Replace Date Here

and u.username not like '%test%'
and u.last_name not like '%test%'
and o.external_org_id = @AO_Key 

and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 


and ci.course_id in (

'5001ba3a-f514-e911-9132-005056b116cc',
'f1268998-4153-e111-8841-0015171350b3',
'184365e3-1b96-11dd-8eed-001517135351',
'cae32881-1b96-11dd-8eed-001517135351',
'4f71f0ef-1b95-11dd-8eed-001517135351',
'4677ef9c-1b97-11dd-8eed-001517135351',
'aaba18fd-1b95-11dd-8eed-001517135351',
'747073de-1b96-11dd-8eed-001517135351',
'46aae88e-4553-e111-8841-0015171350b3',
'0e432871-eb34-11de-a530-0015171c1a75',
'94d3aff9-eb31-11de-a530-0015171c1a75',
'6b35230a-eb36-11de-a530-0015171c1a75',
'27208dc3-eb33-11de-a530-0015171c1a75',
'b0c4a908-eb35-11de-a530-0015171c1a75',
'cd9c232e-eb34-11de-a530-0015171c1a75'

)

order by 1

