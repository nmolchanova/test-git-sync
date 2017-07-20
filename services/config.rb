coreo_aws_rule "cloudtrail-logs-encrypted" do
  action :define
  service :user
  category "Audit"
  link "http://kb.cloudcoreo.com/mydoc_cloudtrail-logs-encrypted.html"
  display_name "Verify CloudTrail logs are encrypted at rest using KMS CMKs"
  suggested_action "It is recommended that CloudTrail be configured to use SSE-KMS."
  description "AWS CloudTrail is a web service that records AWS API calls for an account and makes those logs available to users and resources in accordance with IAM policies. AWS Key Management Service (KMS) is a managed service that helps create and control the encryption keys used to encrypt account data, and uses Hardware Security Modules (HSMs) to protect the security of encryption keys. CloudTrail logs can be configured to leverage server side encryption (SSE) and KMS customer created master keys (CMK) to further protect CloudTrail logs."
  level "Medium"
  meta_cis_id "2.7"
  meta_cis_scored "true"
  meta_cis_level "2"
  meta_nist_171_id "3.3.1"
  objectives [""]
  audit_objects [""]
  operators [""]
  raise_when [true]
  id_map "static.no_op"
end

coreo_aws_rule_runner "cloudtrail-inventory-runner" do
  action :run
  service :cloudtrail
  rules ["cloudtrail-logs-encrypted"]
  regions ${AUDIT_AWS_RDS_REGIONS}
end

coreo_uni_util_jsrunner "test-runner" do
  action :run
  data_type "json"
  provide_composite_access true
  packages([
               {
                   :name => "cloudcoreo-jsrunner-commons",
                   :version => "*"
               },
               {
                   :name => "js-yaml",
                   :version => "3.7.0"
               }
                  ])
  json_input '{"violations":COMPOSITE::coreo_aws_rule_runner.cloudtrail-inventory-runner.report}'
  function <<-EOH
    violations = {};
    callback([violations]);
  EOH
end
