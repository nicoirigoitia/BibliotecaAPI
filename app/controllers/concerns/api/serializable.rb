# frozen_string_literal: true

module Api::Serializable
  extend ActiveSupport::Concern

  def serialize(resource, options = {})
    serializer_class = options[:serializer] || "#{controller_path.classify}Serializer".constantize

    if resource.respond_to?(:each)
      ActiveModelSerializers::SerializableResource.new(resource, each_serializer: serializer_class).as_json
    else
      ActiveModelSerializers::SerializableResource.new(resource, serializer: serializer_class).as_json
    end
  end
end
