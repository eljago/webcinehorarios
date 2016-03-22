CinemaType = GraphQL::ObjectType.define do
  name "Cinema"
  description "A Cinema"

  interfaces [NodeIdentification.interface]
  
  # `id` exposes the UUID
  global_id_field :id
  # field :theaters, types[TheaterType]
  connection :theaters, TheaterType.connection_type do
  	resolve -> (cinema, args, ctx) {
	    cinema.theaters.where(active: true).order(:name)
	  }
  end
  field :name, types.String, "Name of the Cinema"
  field :image, types.String, "URL of the image of the Cinema"
end