# frozen_string_literal: true
# encoding: utf-8

# Minimal model, do not add any fields
class NoAutoId
  include Mongoid::Document

  field :_id
end
