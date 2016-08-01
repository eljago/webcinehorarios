'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'
import FormBuilder from './FormBuilder'

export default class FormBuilderShow extends FormBuilder {

  constructor(show, genres, getPeopleSelectOptions, getVideoTypesOptions) {
    super(show, {
      name: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Nombre',
        initialValuePath: 'name',
      },
      "image": {
        fieldType: 'imageField',
        label: 'Image',
        initialValuePath: 'image.small.url',
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
      },
      imdb_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Imdb Score',
        initialValuePath: 'imdb_score',
      },
      metacritic_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Metacritic Url',
        initialValuePath: 'metacritic_url',
      },
      metacritic_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Metacritic Score',
        initialValuePath: 'metacritic_score',
      },
      rotten_tomatoes_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Rotten Tomatoes Url',
        initialValuePath: 'rotten_tomatoes_url'
      },
      rotten_tomatoes_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Rotten Tomatoes Score',
        initialValuePath: 'rotten_tomatoes_score'
      },
      debut: {
        fieldType: 'dateField',
        label: 'Estreno',
        initialValuePath: 'debut'
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
          person_id: {
            fieldType: 'selectWithImageField',
            label: 'Persona',
            getOptions: getPeopleSelectOptions,
            selectFieldsPaths: {
              value: 'show_person_roles[].id',
              label: 'show_person_roles[].name',
              image_url: 'show_person_roles[].image.smallest.url'
            },
            initialValuePath: 'show_person_roles[].person_id',
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
      },
      videos: {
        fieldType: 'hasManyDynamic',
        submitKey: 'videos_attributes',
        label: 'Videos',
        initialValuePath: 'videos',
        md: 4,
        xs: 12,
        subFields: {
          name: {
            fieldType: 'textField',
            label: 'Nombre',
            initialValuePath: 'videos[].name',
            xs: 12,
          },
          code: {
            fieldType: 'textField',
            label: 'Código',
            initialValuePath: 'videos[].code',
            xs: 8,
          },
          outstanding: {
            fieldType: 'checkboxField',
            label: 'Destacado',
            initialValuePath: 'videos[].outstanding',
            xs: 4
          },
          video_type: {
            fieldType: 'selectField',
            label: 'Tipo',
            getOptions: getVideoTypesOptions,
            selectFieldsPaths: {
              value: 'videos[].video_type',
              label: 'videos[].video_type',
            },
            initialValuePath: 'videos[].video_type',
            xs: 9,
          }
        }
      }
    });
  }
}