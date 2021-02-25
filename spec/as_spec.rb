require 'spec_helper'

#require 'active_storage/engine'
require 'has_secure_token'

class Logo
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_one_attached :image
end

describe 'attachments' do
it 'saves' do
  logo = Logo.new
  logo.image.attach(io: StringIO.new, filename: 'test')
  logo.save!
end
end
