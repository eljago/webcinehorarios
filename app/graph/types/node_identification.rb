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

    if object.is_a?(Show)
      ShowType
    elsif object.is_a?(Theater)
      TheaterType
    elsif object.is_a?(Function)
      ShowFunctionType
    elsif object.is_a?(Cinema)
    	CinemaType
    else
      ViewerType
    end
  end
end