coreo_uni_util_variables "resource_25" do
  action :nothing
end
coreo_uni_util_variables "test-global" do
  action :set
  variables([
                {'GLOBAL::test_var' => 'lalalala'}
            ])
end