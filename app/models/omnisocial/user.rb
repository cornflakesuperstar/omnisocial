module Omnisocial
  class User < ActiveRecord::Base
    has_many :login_accounts, :class_name => 'Omnisocial::LoginAccount', :dependent => :destroy
    validates_presence_of :display_name, :email_address
  
    def facebook_account
      login_accounts.select{|account| account.kind_of? FacebookAccount}.first
    end

    def from_facebook?
      !!facebook_account
    end

    def from_twitter?
      !!twitter_account
    end
  
    def twitter_account
      login_accounts.select{|account| account.kind_of? TwitterAccount}.first
    end

    def remember
      update_attributes(:remember_token => ::BCrypt::Password.create("#{Time.now}-#{self.login_accounts.first.type}-#{self.login_accounts.first.login}")) unless new_record?
    end
  
    def forget
      update_attributes(:remember_token => nil) unless new_record?
    end
  end
end