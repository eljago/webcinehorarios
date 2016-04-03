ShowType = GraphQL::ObjectType.define do
  name "Show"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  field :name, types.String
  field :information, types.String

  field :genres do
  	type types.String
  	resolve -> (show, args, ctx) {
  		show.genres.order(:name).map(&:name).join(', ')
  	}
  end

  connection :functions, -> {ShowFunctionType.connection_type} do
    argument :theater_id, types.Int
    argument :date, types.String
    resolve -> (show, args, ctx) {
  		show.functions.where(functions: {theater_id: args[:theater_id], date: args[:date]})
    }
  end
end