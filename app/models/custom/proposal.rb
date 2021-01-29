require_dependency Rails.root.join("app", "models", "proposal").to_s
class Proposal < ApplicationRecord
  include Search::Generic
end