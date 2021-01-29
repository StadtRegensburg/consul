require_dependency Rails.root.join("app", "models", "site_customization", "page").to_s
class SiteCustomization::Page < ApplicationRecord
  include Search::Generic
end