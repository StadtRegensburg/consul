require_dependency Rails.root.join("app", "models", "debate").to_s
class Debate < ApplicationRecord
  include Search::Generic
end