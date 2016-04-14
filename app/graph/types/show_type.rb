ShowType = GraphQL::ObjectType.define do
  name "Show"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :show_id do
    type types.Int
    resolve -> (show, args, ctx) {
      show.id
    }
  end
  field :name, types.String
  field :information, types.String
  field :image_url, types.String
  field :duration, types.Int

  field :debut do
    type types.String

    resolve -> (show, args, ctx) {
      show.debut.blank? ? nil : I18n.l(show.debut, format: :longi).capitalize
    }
  end

  field :genres do
  	type types.String

  	resolve -> (show, args, ctx) {
  		show.genres.map(&:name).join(', ')
  	}
  end

  field :functions, types[ShowFunctionType]
end