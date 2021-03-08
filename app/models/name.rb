class NameList < ActiveRecord::Base 
    belongs_to :user
    has_many :names 


    validates :name, presence: true

    # def self.list_names
    #     response = 
    # end
end
