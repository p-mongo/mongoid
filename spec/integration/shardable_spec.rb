# frozen_string_literal: true
# encoding: utf-8

require 'spec_helper'
require_relative '../mongoid/shardable_models'

describe 'Sharding helpers' do
  require_topology :sharded

  describe 'shard_collection rake task' do
    let(:shard_collections) do
      Mongoid::Tasks::Database.shard_collections([model_cls])
    end

    let(:create_indexes) do
      Mongoid::Tasks::Database.create_indexes([model_cls])
    end

    shared_examples_for 'shards collection' do
      it 'returns the model class' do
        shard_collections.should == [model_cls]
      end

      it 'shards collection' do
        shard_collections

        stats = model_cls.collection.database.command(collStats: model_cls.collection.name).first
        stats[:sharded].should be true
      end
    end

    context 'simple model' do
      let(:model_cls) { SmMovie }

      before do
        SmMovie.collection.drop
      end

      it_behaves_like 'shards collection'

      it 'makes inserts work' do
        shard_collections
        create_indexes

        SmMovie.create!(year: 2020)
      end
    end

    context 'when database does not exist' do
      let(:model_cls) { SmMovie }

      before do
        SmMovie.collection.database.drop
      end

      it_behaves_like 'shards collection'
    end

    context 'when database exists but collection does not exist' do
      let(:model_cls) { SmMovie }

      before do
        SmMovie.collection.database.drop
        SmMovie.collection.create
        SmMovie.collection.drop
      end

      it_behaves_like 'shards collection'
    end

    context 'when collection is already sharded' do
      let(:model_cls) { SmMovie }

      before do
        Mongoid::Tasks::Database.shard_collections([model_cls])
      end

      it_behaves_like 'shards collection'
    end

    context 'when hashed shard key is given' do
      let(:model_cls) { SmAssistant }

      before do
        SmAssistant.collection.drop
      end

      it_behaves_like 'shards collection'

      it 'makes inserts work' do
        shard_collections
        create_indexes

        SmAssistant.create!(gender: 'm')
      end
    end

    context 'when shard configuration is invalid' do
      let(:model_cls) { SmActor }

      it 'returns empty array' do
        shard_collections.should == []
      end

      it 'does not shards collection' do
        shard_collections

        stats = model_cls.collection.database.command(collStats: model_cls.collection.name).first
        stats[:sharded].should be false
      end

    end
  end
end
