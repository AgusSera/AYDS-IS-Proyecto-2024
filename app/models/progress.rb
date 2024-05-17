class Progress < ActiveRecord::Base
  # relacion 1 a 1 con Progress en la tabla Progress
  has_one :user
end
