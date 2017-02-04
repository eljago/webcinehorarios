class ShowsResolver
  def call(obj, args, ctx)

    date = args[:date].present? ? args[:date].to_date : Date.current
    date_range = date..date+6

    if args[:filter].present?

      case args[:filter]
      when 'billboard'
        return Show.includes(:genres).joins(:functions).where({active: true, functions: {date: date}})
          .order('shows.debut DESC').distinct
      when 'coming_soon'
        return Show.includes(:genres).where('active = ? AND (debut > ? OR debut IS ?)', true, date, nil)
          .order(:debut)
      end

    elsif args[:theater_id].present?  # FUNCTIONS OF A THEATER
      theater = Theater.find(args[:theater_id])
      child_theaters_ids = theater.child_theaters.map(&:id)
      child_theaters_ids << theater.id
      Show.includes(:genres, :functions => [:function_types, :theater]).references(:functions)
        .where(functions: {date: date_range, theater_id: child_theaters_ids})
        .order('shows.debut DESC, function_types.name')
    end
  end
end
