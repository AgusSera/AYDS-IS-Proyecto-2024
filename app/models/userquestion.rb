class UserQuestion < ActiveRecord::Base
  # referencia a la relacion N a N entre User y Question
  belong_to :user
  belong_to :question
end
