coreo_uni_util_jsrunner "tags-to-notifiers-array-rds" do
  action :run
  data_type "json"
  provide_composite_access true
  packages([
               {
                   :name => "cloudcoreo-jsrunner-commons",
                   :version => "1.10.7-15"
               },
               {
                   :name => "js-yaml",
                   :version => "3.7.0"
               }
                  ])
  json_input '{}'
  function <<-EOH
  const CloudCoreoJSRunner = require('cloudcoreo-jsrunner-commons');
  console.log(CloudCoreoJSRunner)
callback();
  EOH
end

coreo_uni_util_variables "test" do
  action :set
  variables([
                {'GLOBAL::test.test2' => 'should be updated'},
                {'GLOBAL::table' => 'COMPOSITE::coreo_uni_util_jsrunner.tags-to-notifiers-array-rds.table'},
                {'COMPOSITE::coreo_uni_util_variables.test.tables' => 'COMPOSITE::coreo_uni_util_jsrunner.tags-to-notifiers-array-rds.table'}
            ])
end

coreo_uni_util_variables "test-global" do
  action :set
  variables([
                {'GLOBAL::results' => 'new value'}
            ])
end