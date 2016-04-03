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

  connection :theaters, TheaterType.connection_type do
    description 'Active Chilean theaters'
    resolve -> (obj, args, ctx) {
      Country.find_by(name: 'Chile').theaters.where(active: true).order([:cinema_id, :name])
    }
  end

  connection :functions, ShowFunctionType.connection_type do
    description 'Get Functions from a theater from a given date'

    argument :theater_id, types.Int, "Functions' theater"
    argument :date, types.String, "Functions' date"
    resolve -> (obj, args, ctx) {
      Function.where({theater_id: args[:theater_id], date: args[:date]})
      # .includes(:show => :genres).order('genres.name')
      # .includes(:function_types).order('function_types.name')
      # .includes(:showtimes).order('showtimes.time')
    }
  end

  field :show do
    type ShowType
    argument :show_id, types.Int, "Show's id"
    resolve -> (obj, args, ctx) {
      Show.find(args[:show_id])
    }
  end

  connection :show_functions, ShowType.connection_type do
    argument :theater_id, types.Int
    argument :date, types.String
    resolve -> (obj, args, ctx) {
      Show.joins(:functions).where(id: 1..Float::INFINITY)
        .where(functions: {theater_id: args[:theater_id], date: args[:date]})
        .order('shows.debut DESC, shows.id').uniq
    }
  end
end