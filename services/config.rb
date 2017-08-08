coreo_aws_rule_runner "test-runner" do
  action :run
  service :iam
  rules []
  regions ${AUDIT_AWS_RDS_REGIONS}
end

coreo_uni_util_jsrunner "test-violation-object" do
  action :run
  data_type "json"
  json_input '{}'
  function <<-EOH
    const testReport = {
        'us-east-1': {
            'testObj': {
                'violations': {
                    'test-violation': {
                        'service': "cloudtrail",
                        'display_name': "Inventory CloudTrail",
                        'result_info': [],
                        'description': "Inventory CloudTrail",
                        'category': "Inventory",
                        'suggested_action': "",
                        'level': "Internal",
                        'link': "http://kb.cloudcoreo.com/",
                        'include_violations_in_count': false,
                        'region': "ap-south-1",
                        'timestamp': 123123123123
                    }
                }
            }
        }
    };
    callback(testReport);
  EOH
end

coreo_uni_util_variables "aws-update-planwide-1" do
  action :set
  variables([
        {'COMPOSITE::coreo_aws_rule_runner.test-runner.report' => 'COMPOSITE::coreo_uni_util_jsrunner.test-violation-object.return'}
    ])
end