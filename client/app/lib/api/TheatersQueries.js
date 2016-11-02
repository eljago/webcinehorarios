'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getTheaters: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/cinemas/${options.cinemaId}/theaters.json`,
      type: 'GET',
      ...options
    }));
  },
  submitNewTheater: (options) => {
    $.ajax(GetQueryContent({
      url: '/api/theaters',
      type: 'POST',
      data: { theaters: options.theater },
      ...options
    }));
  },
  submitEditTheater: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/theaters/${options.theater.id}`,
      type: 'PUT',
      data: { theaters: options.theater },
      ...options
    }));
  },
  submitDeleteTheater: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/theaters/${options.theaterId}`,
      type: 'DELETE',
      ...options
    }));
  }
}