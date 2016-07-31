'use strict'

import validator from 'validator'
import _ from 'lodash'

export default (value, validations) => {
  let failedValidations = {};

  if (_.isString(value) && _.isObject(validations)) {
    _.forIn(validations, (validation, key) => {
      switch (key) {
        case 'matches':
          if (!validator.matches(value, validation.pattern)) {
            failedValidations = _.merge(failedValidations, {
              matches: validation.message
            });
          }
          break;
        case 'isNull':
          if (validator.isNull(value)) {
            failedValidations = _.merge(failedValidations, {
              isNull: 'No puede estar vacío'
            });
          }
          break;
        case 'isURL':
          if (!validator.isURL(value, validation.options)) {
            failedValidations = _.merge(failedValidations, {
              isURL: 'Debe ser una URL'
            });
          }
          break;
        case 'isNumeric':
          if (!validator.isNumeric(value)) {
            failedValidations = _.merge(failedValidations, {
              isNumeric: 'Debe contener solo números'
            });
          }
          break;
        case 'isLength':
          const opts = validation.options;
          if (!validator.isLength(value, opts)) {
            failedValidations = _.merge(failedValidations, {
              isLength: `Debe tener entre ${opts.min} y ${opts.max} caracteres`
            });
          }
          break;
        default:
          break;
      }
    });
  }
  return failedValidations;
}