ViewerType = GraphQL::ObjectType.define do

  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections. Supports fetching posts and users collection'
  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id

  field :api_theaters do
    type types[TheaterType]
    
    argument :cinema_id, types.Int

    resolve -> (obj, args, ctx) {
      Theater.cached_api_theaters args[:cinema_id]
    }
  end

  field :api_theater_shows do
    type types[ShowType]

    argument :theater_id, types.Int
    argument :date, types.String

    resolve -> (obj, args, context) {
      Show.cached_api_theater_shows args[:theater_id], args[:date]
    }
  end

  field :api_billboard do
    type types[ShowType]

    resolve -> (obj, args, context) {
      Show.cached_api_billboard
    }
  end

  field :api_coming_soon do
    type types[ShowType]

    resolve -> (obj, args, context) {
      Show.cached_api_coming_soon
    }
  end
end