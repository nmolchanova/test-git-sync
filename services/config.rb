coreo_aws_rule "rds-inventory" do
  action :define
  service :rds
  # link "http://kb.cloudcoreo.com/mydoc_ec2-inventory.html"
  include_violations_in_count false
  display_name "RDS Instance Inventory"
  description "This rule performs an inventory on all RDS DB instances in the target AWS account."
  category "Inventory"
  suggested_action "None."
  level "Informational"
  objectives ["db_instances"]
  audit_objects ["object.db_instances.db_instance_identifier"]
  operators ["=~"]
  raise_when [//]
  id_map "object.db_instances.db_instance_identifier"
end

coreo_aws_rule_runner "advise-rds" do
  service :rds
  rules ${AUDIT_AWS_RDS_ALERT_LIST}
  action :run
  regions ${AUDIT_AWS_RDS_REGIONS}
end


coreo_uni_util_variables "rds-update-planwide-1" do
  action :set
  variables([
                {'GLOBAL::results' => 'COMPOSITE::coreo_aws_rule_runner.advise-rds.report'}
            ])
end


coreo_uni_util_variables "test-global" do
  action :set
  variables([
                {'GLOBAL::test_var' => 'lalalala'},
                {'GLOBAL::test2' => 'coreo_uni_util_variables'},
            ])
end