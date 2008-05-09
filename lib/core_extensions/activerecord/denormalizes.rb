module Denormalizes
  class NoDenormalizationTargetSpecified < StandardError; end

  def self.included(base)#:nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def denormalizes *attributes
      options = attributes.extract_options!
      raise NoDenormalizationTargetSpecified, 'You must include a denormalization target using :from => :target' unless target = options[:from]

      target_klass        = reflections[target].klass
      target_primary_key  = reflections[target].primary_key_name
      denormalizer_klass  = self

      # This is because the model's attributes hash has String keys, and hash.slice needs matching key types
      attributes.map!(&:to_s)

      # puts "Adding hooks for #{denormalizer_klass} to observe #{target_klass}"
      # Add hooks in the observed model to communicate changes about their state.
      target_klass.instance_eval do
        attr_accessor :denormalizers_config

        # Before the target model is saved, store the new state of the attribute we care about in a safe place
        before_save do |target_instance|
          configs = (target_instance.denormalizers_config ||= {})
          config  = (configs[attributes] ||= {})
          config[:attribute_names] = attributes & target_instance.changed
        end

        # If the object saves successfully, retrieve the map of modified attributes
        after_save do |target_instance|
          config = target_instance.denormalizers_config[attributes]
          attribute_names = config[:attribute_names]
          unless attribute_names.blank?
            attribute_updates = target_instance.attributes.slice(*attribute_names)
            denormalizer = denormalizer_klass.send("find_or_create_by_#{target_primary_key}", target_instance.id, attribute_updates)
            denormalizer.update_attributes(attribute_updates)
          end
        end
      end
      # Done adding hooks


    end
  end

  module InstanceMethods
  end
end

class ActiveRecord::Base
  include Denormalizes
end
