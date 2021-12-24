Ahoy.geocode = false
Ahoy.api = true
Ahoy.server_side_visits = :when_needed

class Ahoy::Store < Ahoy::DatabaseStore

  def visit_model
    Ahoy::Visit
  end

  def authenticate(data)
    # disables automatic linking of visits and users
  end
end
