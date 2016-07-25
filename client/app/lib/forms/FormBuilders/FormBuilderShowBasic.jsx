'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'
import FormBuilder from './FormBuilder'

export default class FormBuilderShowBasic extends FormBuilder {

  constructor(genres) {
    super();
    this.schema = {
      name: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Nombre',
        regExp: new RegExp("^\\b.+\\b$")
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
        regExp: new RegExp("^t{2}\\d{7}$")
      },
      imdb_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Imdb Score',
        regExp: new RegExp("^([0-9]{2})$")
      },
      metacritic_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Metacritic Url',
        regExp: new RegExp("^http://www.metacritic.com/movie/[\\w-]+/?$")
      },
      metacritic_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Metacritic Score',
        regExp: new RegExp("^([0-9]{2})$")
      },
      rotten_tomatoes_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Rotten Tomatoes Url',
        regExp: new RegExp("^https://www.rottentomatoes.com/m/[\\w-]+/?$")
      },
      rotten_tomatoes_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Rotten Tomatoes Score',
        regExp: new RegExp("^([0-9]{2})$")
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
        submitKey: 'genre_ids',
        fieldType: 'checkboxGroupField',
        label: 'Géneros',
        columns: 2,
        options: genres.map((genre) => {
          return {value: genre.id, label: genre.name};
        })
      }
    }
  }
}