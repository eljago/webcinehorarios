'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows/select_shows?input=${options.input}`,
      type: 'GET',
      ...options
    }));
  },
  getPeople: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/people/select_people?input=${options.input}`,
      type: 'GET',
      ...options
    }));
  },
}