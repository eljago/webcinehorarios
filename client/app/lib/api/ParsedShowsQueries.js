'use strict'

import SetHeaders from './SetHeaders';

export default {
  getParsedShows: (options, success, error = null) => {
    $.ajax({
      url: `/api/parsed_shows.json?page=${options.page}&perPage=${options.perPage}`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  getOrphanParsedShows: (success, error = null) => {
    $.ajax({
      url: `/api/parsed_shows/orphan.json`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  submitNewParsedShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/parsed_shows`,
      type: 'POST',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        parsed_shows: options.parsed_show
      }
    });
  },
  submitEditParsedShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/parsed_shows/${options.parsedShowId}`,
      type: 'PUT',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        parsed_shows: options.parsedShow
      }
    });
  },
  submitDeleteParsedShow: (options, success, error = null) => {
    $.ajax({
      url: `/api/parsed_shows/${options.parsedShowId}`,
      type: 'DELETE',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders
    });
  },
}