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
        regExp: /^\b.+\b$/
      },
      remote_image_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Remote Image URL'
      },
      image: {
        fieldType: 'fileField',
        label: 'Local Image'
      },
      information: {
        fieldType: 'textField',
        textFieldType: 'textarea',
        label: 'Synopsis',
      },
      imdb_code: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Imdb Code',
        regExp: /^t{2}\d{7}$/
      },
      imdb_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Imdb Score',
        regExp: /^\d{1,2}$/
      },
      metacritic_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Metacritic Url',
        regExp: /^http:\/\/www\.metacritic\.com\/movie\/[\w-]+\/?$/
      },
      metacritic_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Metacritic Score',
        regExp: /^\d{1,2}$/
      },
      rotten_tomatoes_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Rotten Tomatoes Url',
        regExp: /^https:\/\/www\.rottentomatoes\.com\/m\/[\w-]+\/?$/
      },
      rotten_tomatoes_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Rotten Tomatoes Score',
        regExp: /^\d{1,2}$/
      },
      debut: {
        fieldType: 'dateField',
        label: 'Estreno'
      },
      rating: {
        fieldType: 'radioGroupField',
        label: 'Calificación',
        options: [
          {value: 'TE', label: 'TE'},
          {value: 'TE+7', label: 'TE+7'},
          {value: '14+', label: '14+'},
          {value: '18+', label: '18+'},
        ]
      },
      genres: {
        fieldType: 'checkboxGroupField',
        submitKey: 'genre_ids',
        label: 'Géneros',
        columns: 2,
        options: genres.map((genre) => {
          return {value: genre.id, label: genre.name};
        })
      },
      show_person_roles: {
        fieldType: 'hasManyDynamic',
        submitKey: 'show_person_roles_attributes',
        label: 'Cast',
        subFields: {
          name: {
            fieldType: 'selectField',
            label: 'Persona',
            keyName: 'person_id',
            getOptions: getPeopleSelectOptions
          },
          character: {
            fieldType: 'textField',
            textFieldType: 'text',
            label: 'Personaje',
            regExp: /^\b.+\b$/
          },
          director: {
            fieldType: 'checkboxField',
            label: 'Director'
          },
          actor: {
            fieldType: 'checkboxField',
            label: 'Actor'
          }
        }
      }
    });
  }
}