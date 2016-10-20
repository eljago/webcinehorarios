'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getFunctions: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions?theater_id=${options.theater_id}&date=${options.date}`,
      type: 'GET',
      ...options
    }));
  },
  submitUpdateShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows/update`,
      type: 'PUT',
      data: { shows: options.shows },
      ...options
    }));
  },
  submitEditFunction: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions/${options.func.id}`,
      type: 'PUT',
      data: { functions: options.func },
      ...options
    }));
  },
  submitDeleteFunction: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions/${options.functionId}`,
      type: 'DELETE',
      ...options
    }));
  }
}