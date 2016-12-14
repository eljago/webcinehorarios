ViewerType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections.'
  interfaces [GraphQL::Relay::Node.interface]

  # `id` exposes the UUID
  global_id_field :id

  field :theaters, TheatersField

  field :shows_functions, types[ShowType] do
    argument :cacheTime, types.String
    argument :date, types.String
    argument :theater_id, types.Int
    resolve ->(obj, args, ctx) {
      date = args[:date].present? ? args[:date].to_date : Date.current
      date_range = date..date+6
      Show.includes(:functions => :function_types).references(:functions)
        .where(functions: {date: date_range, theater_id: args[:theater_id]})
        .order('shows.debut DESC, function_types.name ASC')
    }
  end

  field :billboard, types[ShowType] do
    argument :cacheTime, types.String
    argument :date, types.String
    resolve ->(obj, args, ctx) {
      date = args[:date].present? ? args[:date] : Date.current
      Show.joins(:functions).where({active: true, functions: {date: date}})
        .order('shows.debut DESC').distinct
    }
  end

  field :coming_soon, types[ShowType] do
    argument :cacheTime, types.String
    argument :date, types.String
    resolve ->(obj, args, ctx) {
      date = args[:date].present? ? args[:date] : Date.current
      Show.where('active = ? AND (debut > ? OR debut IS ?)', true, date, nil)
        .order(:debut).distinct
    }
  end

  field :show, ShowType do
    argument :cacheTime, types.String
    argument :show_id, types.Int
    resolve ->(obj, args, ctx) {
      Show.find(args[:show_id])
    }
  end

  field :videos, types[VideoType] do
    argument :cacheTime, types.String
    argument :page, types.Int, default_value: 1
    resolve ->(obj, args, ctx) {
      Video.joins(:show)
        .where('shows.active = ? AND videos.outstanding = ?', true, true)
        .order('videos.created_at DESC')
        .paginate(page: args[:page], per_page: 15).uniq
    }
  end
end
