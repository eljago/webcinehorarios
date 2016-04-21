ViewerType = GraphQL::ObjectType.define do

  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections. Supports fetching posts and users collection'
  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id

  field :api_theaters, types[TheaterType] do
    argument :cinema_id, types.Int

    resolve -> (obj, args, ctx) {
      Theater.cached_api_theaters args[:cinema_id]
    }
  end

  field :api_theater_shows, types[ShowType] do
    argument :theater_id, types.Int
    argument :date_start, types.String
    argument :date_end, types.String

    resolve -> (obj, args, context) {
      Show.cached_api_theater_shows args[:theater_id], args[:date_start], args[:date_end]
    }
  end

  field :api_billboard, types[ShowType] do
    resolve -> (obj, args, context) {
      Show.cached_api_billboard
    }
  end

  field :api_coming_soon, types[ShowType] do
    resolve -> (obj, args, context) {
      Show.cached_api_coming_soon
    }
  end

  field :api_show, ShowType do

    argument :show_id, types.Int

    resolve -> (obj, args, context) {
      Show.cached_api_show args[:show_id]
    }
  end
end