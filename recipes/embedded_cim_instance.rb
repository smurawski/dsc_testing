include_recipe 'dsc_testing::default'


dsc_resource 'embeddedcim' do
  resource :embeddedCIM
  property :name, 'testing'
  property :instancearray, ''
