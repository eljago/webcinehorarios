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

    resolve -> (obj, args, ctx){
      Cinema.all
    }
  end

  connection :api_theaters, TheaterType.connection_type do
    description 'Active Chilean theaters'
    resolve -> (obj, args, ctx) {
      Theater.cached_api_theaters
    }
  end

  connection :functions, ShowFunctionType.connection_type do
    description 'Get Functions from a theater from a given date'

    argument :theater_id, types.Int, "Functions' theater"
    argument :date, types.String, "Functions' date"
    resolve -> (obj, args, ctx) {
      Function.where({theater_id: args[:theater_id], date: args[:date]})
    }
  end

  field :show, ShowType

  connection :theater_shows, ShowType.connection_type do
    argument :theater_id, types.Int
    argument :date, types.String
    resolve -> (obj, args, ctx) {
      Show.joins(:functions => :theater).where(functions: {theater_id: args[:theater_id], date: args[:date]})
        .order('shows.debut DESC').uniq
    }
  end
end