'use strict'

export default (props) => {
  return {
    name: {
      label: 'Nombre'
    },
    image: {
      type: 'image',
      label: "Imagen"
    },
    imdb_code: {
      label: 'Código IMDB'
    },
    'delete': {
      alertMessage: "¿Eliminar Persona?",
      onDelete: props.onDelete
    },
    'submit': {
      onSubmit: props.onSubmit
    }
  }
}