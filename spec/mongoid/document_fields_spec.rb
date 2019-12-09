# frozen_string_literal: true
# encoding: utf-8

require "spec_helper"

describe Mongoid::Document do

  describe 'BSON::Binary field' do
    context 'when assigned a BSON::Binary instance' do
      let(:data) do
        BSON::Binary.new('\x00\xfe\xff')
      end

      let(:registry) do
        Registry.new(data: data)
      end

      it 'does not freeze the specified data' do
        registry

        data.should_not be_frozen
      end

      it 'persists' do
        registry.save!

        _registry = Registry.find(registry.id)
        _registry.data.should == data
      end
    end
  end
end
