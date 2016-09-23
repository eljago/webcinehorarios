'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows.json?page=${options.page}&perPage=${options.perPage}&query=${options.searchValue}`,
      type: 'GET',
      ...options
    }));
  },
  getBillboard: (options) => {
    $.ajax(GetQueryContent({
      url: '/api/shows/billboard.json',
      type: 'GET',
      ...options
    }));
  },
  getComingSoon: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows/comingsoon.json`,
      type: 'GET',
      ...options
    }));
  },
  submitNewShow: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows`,
      type: 'POST',
      data: { shows: options.show },
      ...options
    }));
  },
  submitEditShow: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/shows/${options.show.id}`,
      type: 'PUT',
      data: { shows: options.show },
      ...options
    }));
  },
  submitDeleteShow: (options) => {
    $.ajax({
      url: `/api/shows/${options.showId}`,
      type: 'DELETE',
      ...options
    });
  },
}