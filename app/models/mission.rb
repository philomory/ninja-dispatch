class Mission < ActiveRecord::Base
  belongs_to :ninja
  belongs_to :victim
end
