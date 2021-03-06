class VideosResolver
  def call(obj, args, ctx)

    if args[:filter]

      case args[:filter]
      when 'billboard'

        date = args[:date].present? ? args[:date] : Date.current
        Video.includes(:show).references(:show).joins(:show => :functions)
          .where('shows.active = ? AND videos.outstanding = ? AND functions.date = ?', true, true, date)
          .order('shows.debut DESC').distinct

      when 'coming_soon'

        date = args[:date].present? ? args[:date] : Date.current
        Video.includes(:show).references(:show)
          .where('shows.active = ? AND videos.outstanding = ? AND shows.debut > ?', true, true, date)
          .order('shows.debut').distinct

      end

    else

      Video.includes(:show).references(:show)
        .where('shows.active = ? AND videos.outstanding = ?', true, true)
        .order('videos.created_at DESC')

    end
  end
end
