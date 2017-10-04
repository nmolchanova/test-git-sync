
coreo_aws_rule "elb-inventory" do
  action :define
  service :ElasticLoadBalancing
  link "http://kb.cloudcoreo.com/mydoc_all-inventory.html"
  include_violations_in_count false
  display_name "ELB Object Inventory"
  description "This rule performs an inventory on all Classic ELB's in the target AWS account."
  category "Inventory"
  suggested_action "None."
  level "Informational"
  objectives ["load_balancers"]
  audit_objects ["object.load_balancer_descriptions.load_balancer_name"]
  operators ["=~"]
  raise_when [//]
  id_map "object.load_balancer_descriptions.load_balancer_name"
end

coreo_aws_rule "elb-load-balancers-active-security-groups-list" do
  action :define
  service :ElasticLoadBalancing
  include_violations_in_count false
  link "http://kb.cloudcoreo.com/mydoc_unused-alert-definition.html"
  display_name "CloudCoreo Use Only"
  description "This is an internally defined alert."
  category "Internal"
  suggested_action "Ignore"
  level "Internal"
  objectives ["load_balancers"]
  audit_objects ["object.load_balancer_descriptions.security_groups"]
  operators ["=~"]
  raise_when [//]
  id_map "object.load_balancer_descriptions.load_balancer_name"
end

coreo_aws_rule "elb-old-ssl-policy" do
  action :define
  service :ElasticLoadBalancing
  link "http://kb.cloudcoreo.com/mydoc_elb-old-ssl-policy.html"
  display_name "ELB is using old SSL policy"
  description "Elastic Load Balancing (ELB) SSL policy is not the latest Amazon predefined SSL policy or is a custom ELB SSL policy."
  category "Security"
  suggested_action "Always use the current AWS predefined security policy."
  level "High"
  meta_nist_171_id "3.5.4"
  id_map "modifiers.load_balancer_name"
  objectives     ["load_balancers", "load_balancer_policies" ]
  audit_objects  ["", "object.policy_descriptions"]
  call_modifiers [{}, {:load_balancer_name => "load_balancer_descriptions.load_balancer_name"}]
  formulas       ["", "jmespath.[].policy_attribute_descriptions[?attribute_name == 'Reference-Security-Policy'].attribute_value"]
  operators      ["", "!~"]
  raise_when     ["", /\[\"?(?:ELBSecurityPolicy-2016-08)?\"?\]/]
  id_map "modifiers.load_balancer_name"
end

coreo_aws_rule "elb-current-ssl-policy" do
  action :define
  service :ElasticLoadBalancing
  link "http://kb.cloudcoreo.com/mydoc_elb-current-ssl-policy.html"
  include_violations_in_count false
  display_name "ELB is using current SSL policy"
  description "Elastic Load Balancing (ELB) SSL policy is the latest Amazon predefined SSL policy"
  category "Informational"
  suggested_action "None."
  level "Informational"
  id_map "modifiers.load_balancer_name"
  objectives     ["load_balancers", "load_balancer_policies" ]
  audit_objects  ["", "object.policy_descriptions"]
  call_modifiers [{}, {:load_balancer_name => "load_balancer_descriptions.load_balancer_name"}]
  formulas       ["", "jmespath.[].policy_attribute_descriptions[?attribute_name == 'Reference-Security-Policy'].attribute_value"]
  operators      ["", "=~"]
  raise_when     ["", /\[\"?(?:ELBSecurityPolicy-2016-08)?\"?\]/]
  id_map "modifiers.load_balancer_name"
end
git checkout -b CON-200-audit-objects-must-be-prefixed-with-object-var
git add .
git commit -m "CON-200 prefixed 'object' to audit_objects"
git push origin CON-200-audit-objects-must-be-prefixed-with-object-var

coreo_uni_util_variables "elb-planwide" do
  action :set
  variables([
                {'COMPOSITE::coreo_uni_util_variables.elb-planwide.composite_name' => 'PLAN::stack_name'},
                {'COMPOSITE::coreo_uni_util_variables.elb-planwide.plan_name' => 'PLAN::name'},
                {'COMPOSITE::coreo_uni_util_variables.elb-planwide.results' => 'unset'},
                {'GLOBAL::number_violations' => '0'}
            ])
end

coreo_aws_rule_runner "advise-elb" do
  rules ${AUDIT_AWS_ELB_ALERT_LIST}
  service :ElasticLoadBalancing
  action :run
  regions ${AUDIT_AWS_ELB_REGIONS}
  filter(${FILTERED_OBJECTS}) if ${FILTERED_OBJECTS}
end