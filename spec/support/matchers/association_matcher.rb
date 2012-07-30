module RSpec
  module AssociationMatcher
 
    def self.match(subject, name, macro, options)
      if subject.reflections.has_key?(name)
        reflection = subject.reflections[name]
        reflection.macro == macro && reflection.options == options
      end
    end
  end
end

RSpec::Matchers.define(:have_many) do |name, options={}|
  match do |model|
  options = {extend:[]}.merge(options)
  RSpec::AssociationMatcher::match(model, name, :has_many, options)
end
failure_message_for_should do |model|
  " has many #{name} with options #{options.inspect}"
end
end

RSpec::Matchers.define(:belong_to) do |name, options={}|
  match do |model|
  RSpec::AssociationMatcher.match(model, name, :belongs_to, options)
end
failure_message_for_should do |model|
  " belongs_to #{name} with options #{options.inspect}"
end
end
