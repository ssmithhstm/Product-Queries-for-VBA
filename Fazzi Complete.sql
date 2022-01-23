
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
'FB688520-C231-E711-B4F1-005056B133C3',
'02DE3AD1-8739-E711-AB23-005056B14D10',
'E57401DF-8641-E711-8127-005056B104B1',
'50A30847-EC30-E711-94CF-005056B14E7E',
'38661CB4-EA30-E711-94CF-005056B14E7E',
'E41DED09-E830-E711-94CF-005056B14E7E',
'53816779-9452-E711-9FDA-005056B17F9C',
'4BB06D80-DD3C-E711-9C8F-005056B14961',
'669366EA-EA13-E711-9CF6-005056B1723B',
'577EF3BA-9039-E711-AB23-005056B14D10',
'31776BA2-4E41-E711-AD6B-005056B17803',
'45AED8FF-1234-E711-B4F1-005056B133C3',
'102A7AA1-BA3C-E711-87AD-005056B1418B',
'14E0B62E-1534-E711-B4F1-005056B133C3',
'3D668358-7845-E711-979D-005056B14645',
'37AC3C27-8141-E711-9539-005056B1633E',
'5A2B480E-E413-E711-9CF6-005056B1723B',
'8488561A-C13C-E711-9C8F-005056B14961',
'8A4DEA37-9239-E711-AB23-005056B14D10',
'BE3F7DCA-5745-E711-8127-005056B104B1',
'C468294F-5C45-E711-8127-005056B104B1',
'66C1A8C7-E813-E711-9CF6-005056B1723B',
'0717AC8A-EC3B-E711-AB23-005056B14D10',
'8F3096DF-8314-E711-9CF6-005056B1723B',
'FDCFC8E8-FD12-E711-9987-005056B10493',
'C7871355-DC3C-E711-9C8F-005056B14961',
'D02D00C5-2851-E711-9D83-005056B16A47',
'1D88F99F-D93C-E711-9C8F-005056B14961',
'0CDD61A2-5945-E711-8127-005056B104B1',
'B966AF28-5F45-E711-8127-005056B104B1',
'E567D146-5B45-E711-8127-005056B104B1',
'B90EF5C1-DB3C-E711-9C8F-005056B14961',
'7F7631FF-1634-E711-B4F1-005056B133C3',
'A3721EE9-DA3C-E711-9C8F-005056B14961'


)

order by 1
