'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'
import FormBuilder from './FormBuilder'

export default class FormBuilderShow extends FormBuilder {

  constructor(show, genres, getPeopleSelectOptions) {
    super(show, {
      name: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Nombre',
        initialValuePath: 'name',
        validations: {
          isNull: true,
        }
      },
      "image": {
        fieldType: 'imageField',
        label: 'Image',
        initialValuePath: 'image.smaller.url',
      },
      information: {
        fieldType: 'textField',
        textFieldType: 'textarea',
        label: 'Synopsis',
        initialValuePath: 'information'
      },
      imdb_code: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Imdb Code',
        initialValuePath: 'imdb_code',
        validations: {
          matches: {
            pattern: /^t{2}\d{7}$/,
            message: 'Formato del código incorrecto',
          }
        }
      },
      imdb_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Imdb Score',
        initialValuePath: 'imdb_score',
        validations: {
          isLength: {
            options: {
              min: 0,
              max: 2
            }
          },
          isNumeric: true,
        }
      },
      metacritic_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Metacritic Url',
        initialValuePath: 'metacritic_url',
        validations: {
          matches: {
            pattern: /^http:\/\/www\.metacritic\.com\/movie\/[\w-]+\/?$/,
            message: 'Formato de URL incorrecto',
          },
          isURL: {
            options: {
              protocols: ['http', 'https']
            }
          }
        }
      },
      metacritic_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Metacritic Score',
        initialValuePath: 'metacritic_score',
        validations: {
          isLength: {
            options: {
              min: 0,
              max: 2
            }
          },
          isNumeric: true,
        }
      },
      rotten_tomatoes_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Rotten Tomatoes Url',
        initialValuePath: 'rotten_tomatoes_url',
        validations: {
          matches: {
            pattern: /^https:\/\/www\.rottentomatoes\.com\/m\/[\w-]+\/?$/,
            message: 'Formato de URL incorrecto',
          },
          isURL: {
            options: {
              protocols: ['http', 'https']
            }
          }
        },
      },
      rotten_tomatoes_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Rotten Tomatoes Score',
        initialValuePath: 'rotten_tomatoes_score',
        validations: {
          isLength: {
            options: {
              min: 0,
              max: 2
            }
          },
          isNumeric: true,
        }
      },
      debut: {
        fieldType: 'dateField',
        label: 'Estreno',
        initialValuePath: 'debut',
        validations: {
          matches: {
            pattern: /^\d{2}-\d{2}-\d{4}$/,
            message: 'Formato de Fecha Incorrecto',
          }
        }
      },
      rating: {
        fieldType: 'radioGroupField',
        label: 'Calificación',
        options: [
          {value: 'TE', label: 'TE'},
          {value: 'TE+7', label: 'TE+7'},
          {value: '14+', label: '14+'},
          {value: '18+', label: '18+'},
        ],
        initialValuePath: 'rating'
      },
      genres: {
        fieldType: 'checkboxGroupField',
        submitKey: 'genre_ids',
        label: 'Géneros',
        xs: 6,
        options: genres.map((genre) => {
          return {value: genre.id, label: genre.name};
        }),
        initialValuePath: 'genres'
      },
      show_person_roles: {
        fieldType: 'hasManyDynamic',
        submitKey: 'show_person_roles_attributes',
        label: 'Elenco',
        initialValuePath: 'show_person_roles',
        xs: 12,
        subFields: {
          name: {
            fieldType: 'selectField',
            label: 'Persona',
            keyName: 'person_id',
            getOptions: getPeopleSelectOptions,
            initialValuePath: 'show_person_roles[]',
            xs: 12,
            md: 6
          },
          character: {
            fieldType: 'textField',
            textFieldType: 'text',
            label: 'Personaje',
            initialValuePath: 'show_person_roles[].character',
            xs: 12,
            md: 3
          },
          director: {
            fieldType: 'checkboxField',
            label: 'Director',
            initialValuePath: 'show_person_roles[].director',
            xs: 5,
            md: 1
          },
          actor: {
            fieldType: 'checkboxField',
            label: 'Actor',
            initialValuePath: 'show_person_roles[].actor',
            xs: 5,
            md: 1
          }
        }
      },
      images: {
        fieldType: 'hasManyDynamic',
        submitKey: 'images_attributes',
        label: 'Imágenes',
        initialValuePath: 'images',
        xs: 12,
        md: 6,
        subFields: {
          "image": {
            fieldType: 'imageField',
            label: 'Image',
            initialValuePath: 'images[].image.smaller.url',
            md: 10,
          },
        }
      }
    });
  }
}