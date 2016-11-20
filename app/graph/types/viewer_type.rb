ViewerType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections.'
  interfaces [GraphQL::Relay::Node.interface]

  # `id` exposes the UUID
  global_id_field :id

  field :theaters, TheatersField

  field :shows_functions, types[ShowType] do
    argument :date, types.String, default_value: Date.current
    argument :theater_id, types.Int
    resolve ->(obj, args, ctx) {
      date = args[:date].to_date
      date_range = date..date+6
      Show.includes(:functions => :function_types).references(:functions)
        .where(functions: {date: date_range, theater_id: args[:theater_id]})
        .order('shows.debut DESC, function_types.name ASC')
    }
  end

  field :billboard, types[ShowType] do
    argument :date, types.String, default_value: Date.current
    resolve ->(obj, args, ctx) {
      Show.joins(:functions).where({active: true, functions: {date: args[:date]}})
        .order('shows.debut DESC').distinct
    }
  end

  field :coming_soon, types[ShowType] do
    argument :date, types.String, default_value: Date.current
    resolve ->(obj, args, ctx) {
      Show.where('active = ? AND (debut > ? OR debut IS ?)', true, args[:date], nil)
        .order(:debut).distinct
    }
  end
end
