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
    name_original: {
      label: "Nombre Original"
    },
    year: {
      type: 'number',
      label: 'Año'
    },
    duration: {
      type: 'number',
      label: 'Duración'
    },
    debut: {
      label: 'Estreno'
    },
    information: {
      type: 'textarea',
      label: 'Sinopsis'
    },
    imdb_code: {
      label: 'IMDB Code'
    },
    imdb_score: {
      type: 'number',
      label: 'IMDB Score'
    },
    metacritic_url: {
      label: 'Metacritic URL'
    },
    metacritic_score: {
      type: 'number',
      label: 'Metacritic Score'
    },
    rotten_tomatoes_url: {
      label: 'Rotten Tomatoes URL'
    },
    rotten_tomatoes_score: {
      type: 'number',
      label: 'Rotten Tomatoes Score'
    },
    genres: {
      type: 'checkboxGroup',
      label: 'Géneros',
      submitKey: 'genre_ids',
      options: props.genres
    },
    rating: {
      type: 'radioGroup',
      label: 'Calificación',
      options: [
        {value: 'TE', label: 'TE'},
        {value: 'TE+7', label: 'TE+7'},
        {value: '14+', label: '14+'},
        {value: '18+', label: '18+'},
      ]
    },
    show_person_roles: {
      type: 'nested',
      label: 'Elenco',
      submitKey: 'show_person_roles_attributes',
      defaultObject: props.defaultShowPersonRole,
      nestedSchema: {
        person_id: {
          type: 'select',
          label: 'Elenco',
          getOptions: SelectQueries.getPeopleOptions,
        },
        character: {
          label: 'Personaje'
        },
        director: {
          type: 'checkbox',
          label: 'Director'
        },
        actor: {
          type: 'checkbox',
          label: 'Actor'
        }
      }
    },
    images: {
      type: 'nested',
      label: 'Imágenes',
      submitKey: 'images_attributes',
      defaultObject: props.defaultImage,
      nestedSchema: {
        image: {
          type: 'image',
          label: 'Imagen'
        },
        backdrop: {
          type: 'checkbox',
          label: 'Backdrop'
        },
        poster: {
          type: 'checkbox',
          label: 'Poster'
        }
      }
    },
    videos: {
      type: 'nested',
      label: 'Videos',
      submitKey: 'videos_attributes',
      defaultObject: props.defaultVideo,
      nestedSchema: {
        name: {
          label: 'Nombre'
        },
        outstanding: {
          type: 'checkbox',
          label: 'Outstanding'
        },
        code: {
          label: 'Código'
        },
        video_type: {
          type: 'select',
          label: 'Tipo',
          options: props.videoTypes,
          async: false
        }
      }
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