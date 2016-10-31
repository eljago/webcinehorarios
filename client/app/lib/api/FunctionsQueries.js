'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getFunctions: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions?theater_id=${options.theaterId}&date=${options.date}`,
      type: 'GET',
      ...options
    }));
  },
  submitUpdateShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows/update_shows`,
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
  },
  copyDay: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions/copy_day?theater_id=${options.theaterId}&date=${options.date}`,
      type: 'POST',
      ...options
    }));
  },
  deleteDay: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions/delete_day?theater_id=${options.theaterId}&date=${options.date}`,
      type: 'DELETE',
      ...options
    }));
  },
  deleteOnward: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/functions/delete_onward?theater_id=${options.theaterId}&date=${options.date}`,
      type: 'DELETE',
      ...options
    }));
  }
}