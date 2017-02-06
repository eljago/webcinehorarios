class ShowResolver
  def call(obj, args, ctx)
    if args[:show_id]
      Show.find(args[:show_id])
    end
  end
end
