# frozen_string_literal: true
# encoding: utf-8

module Mongoid
  module Errors

    # Raised when a model instance doesn't have an _id value but the value
    # is required for an operation.
    class NoId < MongoidError

      # Create the new no id error.
      def initialize
        super(compose_message("no_id", {}))
      end
    end
  end
end
