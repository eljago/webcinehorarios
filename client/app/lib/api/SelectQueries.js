'use strict'

import SetHeaders from './SetHeaders';

export default {
  getShows: (input, success, error = null) => {
    $.ajax({
      url: `/api/shows/select_shows?input=${input}`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  getPeople: (input, success, error = null) => {
    $.ajax({
      url: `/api/people/select_people?input=${input}`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
}