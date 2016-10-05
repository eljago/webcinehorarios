'use strict'

import {SelectQueries} from '../../../lib/api/queries'

export default (props) => {
  return {
    show_id: {
      type: 'select',
      label: 'Película',
      getOptions: SelectQueries.getShowsOptions,
    },
    function_types: {
      type: 'checkboxGroup',
      label: 'Tipos de Función',
      submitKey: 'function_type_ids',
      options: props.function_types,
    },
    showtimes: {
      label: props.date,
    },
    'delete': {
      alertMessage: "¿Eliminar Show?",
      onDelete: props.onDelete,
    },
    'submit': {
      onSubmit: props.onSubmit
    }
  }
}