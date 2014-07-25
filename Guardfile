
group 'specs' do
  guard 'rspec', :cmd => 'bundle exec rspec' do
    # Regexp watch patterns are matched with Regexp#match
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})         { |m| "spec/lib/#{m[1]}_spec.rb" }

    watch('spec/spec_helper.rb') { "spec" }
  end
end

group 'cukes' do
  guard 'cucumber', :cli => '--tags ~@slow' do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$})                      { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  end
end

