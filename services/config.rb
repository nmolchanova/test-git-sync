coreo_aws_rule "iam-inactive-key-no-rotation" do
  action :define
  service :iam
  link "http://kb.cloudcoreo.com/mydoc_iam-inactive-key-no-rotation.html"
  display_name "User Has Access Keys Inactive and Un-rotated"
  description "User has inactive keys that have not been rotated in the last 90 days."
  category "Access"
  suggested_action "If you regularly use the AWS access keys, we recommend that you also regularly rotate or delete them."
  level "High"
  meta_nist_171_id "3.5.9"
  id_map "modifier.user_name"
  objectives ["users", "access_keys", "access_keys"]
  audit_objects ["", "access_key_metadata.status", "access_key_metadata.create_date"]
  call_modifiers [{}, {:user_name => "users.user_name"}, {:user_name => "users.user_name"}]
  operators ["", "==", "<"]
  raise_when ["", "Inactive", "90.days.ago"]
end

coreo_aws_rule_runner "iam-runner" do
  action :run
  service :iam
  rules ["iam-inactive-key-no-rotation"]
  regions ${AUDIT_AWS_RDS_REGIONS}
end