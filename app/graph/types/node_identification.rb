NodeIdentification = GraphQL::Relay::GlobalNodeIdentification.define do
  # Given a UUID & the query context,
  # return the corresponding application object
  object_from_id -> (id, ctx) do
    type_name, id = NodeIdentification.from_global_id(id)
    # "Post" -> Post.find(id)
    Object.const_get(type_name).find(id)
  end

  # Given an application object,
  # return a GraphQL ObjectType to expose that object
  type_from_object -> (object) do

    if object.is_a? Show
      ShowType
    elsif object.is_a? Theater
      TheaterType
    elsif object.is_a? Function
      ShowFunctionType
    elsif object.is_a? Cinema
    	CinemaType
    elsif object.is_a? Video
      VideoType
    elsif object.is_a? Image
      ImageType
    elsif object.is_a? Person
      PersonType
    else
      ViewerType
    end
  end
end