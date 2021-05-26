# frozen_string_literal: true
# encoding: utf-8

require 'spec_helper'

describe Mongoid::Document do
  describe '#current_selector' do
    context 'not sharded' do
      context 'for new document' do
        let(:doc) { Strategy.new }

        it 'includes id value' do
          doc.id.should be_a(BSON::ObjectId)
          doc.current_selector.should == {'_id' => doc.id}
        end
      end

      context 'when _id value is not set in the document' do
        let(:doc) { NoAutoId.new }

        it 'raises ArgumentError' do
          doc.id.should be nil
          lambda do
            doc.current_selector
          end.should raise_error(Mongoid::Errors::NoId)
        end
      end

      context 'for embedded document' do
        let(:doc) { Birthday.new }

        it 'raises ArgumentError' do
          doc.id.should be_a(BSON::ObjectId)
          lambda do
            doc.current_selector
          end.should raise_error(ArgumentError, /current_selector is only defined for top-level documents/)
        end
      end
    end
  end
end
