RelaySchema = GraphQL::Schema.new(query: QueryType)
RelaySchema.query_execution_strategy = GraphQL::Batch::ExecutionStrategy
