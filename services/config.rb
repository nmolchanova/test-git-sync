coreo_uni_util_jsrunner "tags-to-notifiers-array-rds" do
  action :run
  data_type "json"
  provide_composite_access true
  packages([
               {
                   :name => "cloudcoreo-jsrunner-commons",
                   :version => "1.10.7-9"
               },
               {
                   :name => "js-yaml",
                   :version => "3.7.0"
               }
                  ])
  json_input '{}'
  function <<-EOH
function setTableAndSuppression() {
  let table;
  let suppression;
  const fs = require('fs');
  const yaml = require('js-yaml');
  try {
      suppression = yaml.safeLoad(fs.readFileSync('./suppression.yaml', 'utf8'));
  } catch (e) {
      console.log("Error reading suppression.yaml file: " , e);
      suppression = {};
  }
  try {
      table = yaml.safeLoad(fs.readFileSync('./table.yaml', 'utf8'));
  } catch (e) {
      console.log("Error reading table.yaml file: ", e);
      table = {};
  }
  coreoExport('table', JSON.stringify(table));
  coreoExport('suppression', JSON.stringify(suppression));
}
setTableAndSuppression();
callback();
  EOH
end

coreo_uni_util_variables "test" do
  action :set
  variables([
                {'GLOBAL::results' => 'should be updated'},
                {'GLOBAL::table' => COMPOSITE::coreo_uni_util_jsrunner.tags-to-notifiers-array-rds.table}
            ])
end

coreo_uni_util_variables "test-global" do
  action :set
  variables([
                {'GLOBAL::results' => 'new value'}
            ])
end