'use strict'

import SetHeaders from './SetHeaders';

export default {
  getShows: (options, success, error = null) => {
    $.ajax({
      url: `/api/shows.json?page=${options.page}&perPage=${options.perPage}&query=${options.searchValue}`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  getBillboard: (success, error = null) => {
    $.ajax({
      url: '/api/shows/billboard.json',
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  getComingSoon: (success, error = null) => {
    $.ajax({
      url: `/api/shows/comingsoon.json`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  submitNewShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/shows`,
      type: 'POST',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        shows: options.show
      }
    });
  },
  submitEditShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/shows/${options.show.id}`,
      type: 'PUT',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        shows: options.show
      }
    });
  },
  submitDeleteShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/shows/${options.showId}`,
      type: 'DELETE',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders
    });
  },
}