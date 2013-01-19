require 'facebook/identity'

module Facebook
  class BasicUser < Facebook::Identity
    attr_reader :id, :name, :first_name, :last_name, :link, :username, :gender, :locale
  end
end
