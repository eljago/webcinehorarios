class ShowsResolver
  def call(obj, args, ctx)

    if args[:filter].present?

      case args[:filter]
      when 'billboard'
        date = args[:date].present? ? args[:date] : Date.current
        Show.joins(:functions).where({active: true, functions: {date: date}})
          .order('shows.debut DESC').distinct
      when 'coming_soon'
        date = args[:date].present? ? args[:date] : Date.current
        Show.where('active = ? AND (debut > ? OR debut IS ?)', true, date, nil)
          .order(:debut).distinct
      end

    elsif args[:theater_id].present?

      date = args[:date].present? ? args[:date].to_date : Date.current
      date_range = date..date+6
      theater = Theater.find(args[:theater_id])
      child_theaters_ids = theater.child_theaters.map(&:id)
      child_theaters_ids << theater.id
      puts child_theaters_ids
      Show.includes(:genres, :functions => :function_types).references(:functions)
        .where(functions: {date: date_range, theater_id: child_theaters_ids})
        .order('shows.debut DESC, function_types.name ASC')

    elsif args[:show_id].present?

      Show.find(args[:show_id])

    end
  end
end