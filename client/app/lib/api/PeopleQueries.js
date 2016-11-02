'use strict'

import GetQueryContent from './GetQueryContent';

export default {
  getPeople: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/people.json?page=${options.page}&perPage=${options.perPage}&query=${options.searchValue}`,
      type: 'GET',
      ...options
    }));
  },
  submitNewPerson: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/people`,
      type: 'POST',
      data: { people: options.person },
      ...options
    }));
  },
  submitEditPerson: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/people/${options.person.id}`,
      type: 'PUT',
      data: { people: options.person },
      ...options
    }));
  },
  submitDeletePerson: (options) => {
    $.ajax(GetQueryContent({
      url: `/api/people/${options.personId}`,
      type: 'DELETE',
      ...options
    }));
  },
}