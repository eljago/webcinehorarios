RelaySchema = GraphQL::Schema.define do
  query QueryType

  max_depth 7

  object_from_id -> (id, ctx) { decode_object(id) }
  id_from_object -> (obj, type, ctx) { encode_object(obj, type) }
  rescue_from ActiveRecord::RecordInvalid, &:message
  rescue_from ActiveRecord::Rollback, &:message
  rescue_from StandardError, &:message
  rescue_from ActiveRecord::RecordNotUnique, &:message
  rescue_from ActiveRecord::RecordNotFound, &:message
  resolve_type -> (object, _ctx) { RelaySchema.types[type_name(object)] }
end

def type_name(object)
  object.class.name
end

def encode_object(object, type)
  GraphQL::Schema::UniqueWithinType.encode(type.name, object.id)
end

def decode_object(id)
  type_name, object_id = GraphQL::Schema::UniqueWithinType.decode(id)
  Object.const_get(type_name).find(object_id)
end