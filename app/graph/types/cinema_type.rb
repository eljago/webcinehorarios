CinemaType = GraphQL::ObjectType.define do
  name "Cinema"
  description "A Cinema"

  interfaces [NodeIdentification.interface]
  
  # `id` exposes the UUID
  global_id_field :id

  field :cinema_id do
    type types.Int
    resolve -> (cinema, args, ctx) {
      cinema.id
    }
  end

  field :name, types.String, "Name of the Cinema"
  field :image, types.String, "URL of the image of the Cinema"

  connection :theaters, TheaterType.connection_type do
  	resolve -> (cinema, args, ctx) {
	    cinema.theaters.where(active: true).order(:name)
	  }
  end
end