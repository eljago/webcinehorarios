ViewerType = GraphQL::ObjectType.define do

  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections. Supports fetching posts and users collection'
  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id

  # Fetch all posts
  connection :cinemas, CinemaType.connection_type do
    description 'Cinemas'

    resolve -> (object, args, ctx){
      Cinema.all
    }
  end

  connection :theaters, TheaterType.connection_type do
    description 'Active Chilean theaters'
    resolve -> (obj, args, ctx) {
      Country.find_by(name: 'Chile').theaters.where(active: true).order([:cinema_id, :name])
    }
  end

  field :show do
    type ShowType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      Show.find(args[:id])
    }
  end
  
end