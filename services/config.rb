coreo_uni_util_notify "advise-s3-json" do
  action :nothing
  type 'email'
  allow_empty ${AUDIT_AWS_S3_ALLOW_EMPTY}
  send_on '${AUDIT_AWS_S3_SEND_ON}'
  payload '{"composite name":"PLAN::stack_name",
  "plan name":"PLAN::name",
  "number_of_checks":"COMPOSITE::coreo_aws_advisor_s3.advise-s3.number_checks",
  "number_of_violations":"COMPOSITE::coreo_aws_advisor_s3.advise-s3.number_violations",
  "number_violations_ignored":"COMPOSITE::coreo_aws_advisor_s3.advise-s3.number_ignored_violations",
  "violations": COMPOSITE::coreo_aws_advisor_s3.advise-s3.report }'
  payload_type "json"
  endpoint ({
      :to => 'test', :subject => 'CloudCoreo s3 advisor alerts on PLAN::stack_name :: PLAN::name'
  })
end

coreo_uni_util_notify "advise-s3-to-tag-values" do
  action :nothing
  notifiers 'COMPOSITE::coreo_uni_util_jsrunner.tags-to-notifiers-array-s3.return'
end

coreo_uni_util_variables "resource_25" do
  action :nothing
end