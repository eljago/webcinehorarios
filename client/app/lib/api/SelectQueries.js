'use strict'

import _ from 'lodash';

import GetQueryContent from './GetQueryContent';

export default {
  getPeopleOptions: (input, callback) => {
    if (_.trim(input).length > 2) {
      getPeople({
        input: input,
        success: (response) => {
          callback(null, {
            options: response.people
          });
        }
      });
    }
    else {
      callback(null, {options: []});
    }
  },
  getShowsOptions: (input, callback) => {
    if (_.trim(input).length > 2) {
      getShows({
        input: input,
        success: (response) => {
          callback(null, {
            options: response.shows,
          });
        }
      });
    }
    else {
      callback(null, {options: []});
    }
  }
}

const getShows = (options) => {
  $.ajax(GetQueryContent({
    url: `/api/shows/select_shows?input=${options.input}`,
    type: 'GET',
    ...options
  }));
};

const getPeople = (options) => {
  $.ajax(GetQueryContent({
    url: `/api/people/select_people?input=${options.input}`,
    type: 'GET',
    ...options
  }));
};