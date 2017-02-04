class TheatersResolver
  def call(obj, args, ctx)
    if args[:cinema_id].present?
      if args[:show_id].present?
        keys = ctx.irep_node.typed_children[TheaterType].keys
        date = args[:date].present? ? args[:date].to_date : Date.current
        date_range = date..date+6
        ids = Theater.where(cinema_id: args[:cinema_id], active: true).map(&:id)
        if keys.include? 'functions'
          Theater.includes(functions: :function_types)
            .where('(theaters.id IN (?) AND theaters.active = ?) OR theaters.parent_theater_id IN (?)',ids, true, ids)
            .where(cinema_id: args[:cinema_id], functions: {show_id: args[:show_id], date: date_range})
            .order('theaters.cinema_id, theaters.name, function_types.name')
        else
          Theater.joins(:functions)
            .where('(theaters.id IN (?) AND theaters.active = ?) OR theaters.parent_theater_id IN (?)',ids, true, ids)
            .where(cinema_id: args[:cinema_id], functions: {show_id: args[:show_id], date: date_range})
            .order('theaters.cinema_id, theaters.name')
            .distinct
        end
      else
        Theater.where(cinema_id: args[:cinema_id], active: true).order(:name)
      end
    elsif args[:show_id].present? && args[:theater_ids].present?
      ids = args[:theater_ids].split(',')
      date = args[:date].present? ? args[:date].to_date : Date.current
      date_range = date..date+6
      Theater.includes(functions: :function_types)
        .where('(theaters.id IN (?) AND theaters.active = ?) OR theaters.parent_theater_id IN (?)',ids, true, ids)
        .where(functions: {show_id: args[:show_id], date: date_range})
        .order('theaters.cinema_id, theaters.name, function_types.name')
    else
      Theater.where(active: true).order(:cinema_id, :name)
    end
  end
end
