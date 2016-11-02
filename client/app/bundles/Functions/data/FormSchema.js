'use strict'

import {SelectQueries} from '../../../lib/api/queries'

export default (props) => {
  return {
    functions: {
      type: 'nested',
      label: 'Funciones',
      submitKey: 'functions_attributes',
      defaultObject: props.defaultFunction,
      nestedSchema: {
        function_types: {
          type: 'checkboxGroup',
          label: 'Tipos de Función',
          submitKey: 'function_type_ids',
          options: props.function_types,
        },
        showtimes: {
          label: 'Showtimes',
        },
        date: {
          type: 'hidden'
        },
        theater_id: {
          type: 'hidden'
        },
        show_id: {
          type: 'hidden'
        }
      }
    }
  }
}