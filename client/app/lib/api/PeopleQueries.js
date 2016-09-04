'use strict'

import SetHeaders from './SetHeaders';

export default {
  getPeople: (options, success, error = null) => {
    $.ajax({
      url: `/api/people.json?page=${options.page}&perPage=${options.perPage}&query=${options.searchValue}`,
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
    });
  },
  submitNewPerson: (options, success, error = null) => {
    $.ajax({
      url: `/api/people`,
      type: 'POST',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        people: options.person
      }
    });
  },
  submitEditPerson: (options, success, error = null) => {
    $.ajax({
      url: `/api/people/${options.person.id}`,
      type: 'PUT',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders,
      data: {
        people: options.person
      }
    });
  },
  submitDeletePerson: (options, success, error = null) => {
    $.ajax({
      url: `/api/people/${options.personId}`,
      type: 'DELETE',
      dataType: 'json',
      success: success,
      error: error,
      beforeSend: SetHeaders
    });
  },
}