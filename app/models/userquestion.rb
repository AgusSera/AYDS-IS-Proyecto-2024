class UserQuestion < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Question
  belongs_to :user
  belongs_to :question
end
