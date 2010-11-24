module Omnisocial
  class LoginAccount
    include Mongoid::Document
    include Mongoid::Timestamps
    
    referenced_in :user
  
    field :token
    field :secret
    field :remote_account_id
    field :name
    field :login
    field :picture_url
  
    def self.find_or_create_from_auth_hash(auth_hash)
      if (account = first(:conditions => {:remote_account_id => auth_hash['uid']}))
        account.assign_account_info(auth_hash)
        account.save
        account
      else
        create_from_auth_hash(auth_hash)
      end
    end
  
    def self.create_from_auth_hash(auth_hash)
      account = create!
      account.assign_account_info(auth_hash)
      account
    end
  
  end
end