'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getParsedShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/parsed_shows.json?page=${options.page}&perPage=${options.perPage}`,
      type: 'GET',
      ...options
    }));
  },
  getOrphanParsedShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/parsed_shows/orphan.json`,
      type: 'GET',
      ...options
    }));
  },
  getRelevantParsedShows: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/parsed_shows/relevant.json`,
      type: 'GET',
      ...options
    }));
  },
  submitNewParsedShow: (options) => {
    $.ajax(GetQueryContent({
      url: '/api/parsed_shows',
      type: 'POST',
      data: { parsed_shows: options.parsed_show },
      ...options
    }));
  },
  submitEditParsedShow: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/parsed_shows/${options.parsedShowId}`,
      type: 'PUT',
      data: { parsed_shows: options.parsedShow },
      ...options
    }));
  },
  submitDeleteParsedShow: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/parsed_shows/${options.parsedShowId}`,
      type: 'DELETE',
      ...options
    }));
  },
}