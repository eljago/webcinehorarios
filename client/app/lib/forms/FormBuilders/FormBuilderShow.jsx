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
        regExp: /^\b.+\b$/,
        initialValuePath: 'name'
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
        regExp: /^t{2}\d{7}$/,
        initialValuePath: 'imdb_code'
      },
      imdb_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Imdb Score',
        regExp: /^\d{1,2}$/,
        initialValuePath: 'imdb_score'
      },
      metacritic_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Metacritic Url',
        regExp: /^http:\/\/www\.metacritic\.com\/movie\/[\w-]+\/?$/,
        initialValuePath: 'metacritic_url'
      },
      metacritic_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Metacritic Score',
        regExp: /^\d{1,2}$/,
        initialValuePath: 'metacritic_score'
      },
      rotten_tomatoes_url: {
        fieldType: 'textField',
        textFieldType: 'text',
        label: 'Rotten Tomatoes Url',
        regExp: /^https:\/\/www\.rottentomatoes\.com\/m\/[\w-]+\/?$/,
        initialValuePath: 'rotten_tomatoes_url'
      },
      rotten_tomatoes_score: {
        fieldType: 'textField',
        textFieldType: 'number',
        label: 'Rotten Tomatoes Score',
        regExp: /^\d{1,2}$/,
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
        columns: 2,
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
        subFields: {
          name: {
            fieldType: 'selectField',
            label: 'Persona',
            keyName: 'person_id',
            getOptions: getPeopleSelectOptions,
            initialValuePath: 'show_person_roles[].name',
            col: 2,
          },
          character: {
            fieldType: 'textField',
            textFieldType: 'text',
            label: 'Personaje',
            regExp: /^\b.+\b$/,
            initialValuePath: 'show_person_roles[].character',
            col: 3,
          },
          director: {
            fieldType: 'checkboxField',
            label: 'Director',
            initialValuePath: 'show_person_roles[].director',
            col: 3,
          },
          actor: {
            fieldType: 'checkboxField',
            label: 'Actor',
            initialValuePath: 'show_person_roles[].actor',
            col: 3,
          }
        }
      },
      images: {
        fieldType: 'hasManyDynamic',
        submitKey: 'images_attributes',
        label: 'Imágenes',
        initialValuePath: 'images',
        subFields: {
          "image": {
            fieldType: 'imageField',
            label: 'Image',
            initialValuePath: 'images[].image.smaller.url',
            col: 10,
          },
        }
      }
    });
  }
}