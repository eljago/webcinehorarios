ShowType = GraphQL::ObjectType.define do
  name "Show"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :name, types.String
  field :information, types.String
  field :image_url, types.String

  field :genres do
  	type types.String

  	resolve -> (show, args, ctx) {
  		show.genres.map(&:name).join(', ')
  	}
  end

  field :functions, types[ShowFunctionType]
end