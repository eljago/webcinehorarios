'use strict'

import {SelectQueries} from '../../../lib/api/queries'

export default (props) => {
  return {
    active: {
      type: 'checkbox',
      label: 'Activo'
    },
    name: {
      label: 'Nombre'
    },
    address: {
      label: "Dirección"
    },
    web_url: {
      label: 'Web URL'
    },
    parse_helper: {
      label: 'Parse Helper'
    },
    information: {
      type: 'text',
      label: 'Información'
    },
    parent_theater_id: {
      type: 'select',
      label: 'Parent Theater',
      getOptions: SelectQueries.getTheatersOptions,
    },
    latitude: {
      type: 'number',
      label: 'Latitud'
    },
    longitude: {
      type: 'number',
      label: 'Longitud'
    },
    'delete': {
      alertMessage: "¿Eliminar Show?",
      onDelete: props.onDelete
    },
    'submit': {
      onSubmit: props.onSubmit
    }
  }
}