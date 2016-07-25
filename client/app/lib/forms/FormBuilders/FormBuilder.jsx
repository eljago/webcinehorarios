'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldText from '../FormFields/FormFieldText'
import FormFieldFile from '../FormFields/FormFieldFile'
import FormFieldSelect from '../FormFields/FormFieldSelect'
import FormFieldDate from '../FormFields/FormFieldDate'
import FormFieldRadioGroup from '../FormFields/FormFieldRadioGroup'
import FormFieldCheckboxGroup from '../FormFields/FormFieldCheckboxGroup'

export default class FormBuilder {

  constructor(schema) {
    this.schema = schema;
  }

  getFormField(object, fieldId) {
    if (_.has(this.schema, fieldId)) {
      const fieldInfo = this.schema[fieldId];
      const fieldType = fieldInfo.fieldType;

      const formFieldProps = {
        ref: fieldId,
        controlId: fieldInfo.controlId ? fieldInfo.controlId : fieldId,
        label: fieldInfo.label
      }
      let aditionalProps;

      if (fieldType === 'textField') {
        if (fieldInfo.textFieldType === 'number') {
          aditionalProps = {
            type: 'number',
            regExp: fieldInfo.regExp,
            initialValue: object[fieldId]
          };
        }
        else if (fieldInfo.textFieldType === 'textarea') {
          aditionalProps = {
            type: 'textarea',
            initialValue: object[fieldId]
          };
        }
        else {
          aditionalProps = {
            type: 'text',
            regExp: fieldInfo.regExp,
            initialValue: object[fieldId]
          };
        }
        return (
          <FormFieldText
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'fileField') {
        return (
          <FormFieldFile {...formFieldProps} />
        );
      }
      else if (fieldType === 'dateField') {
        aditionalProps = {
          initialValue: object[fieldId]
        };
        return (
          <FormFieldDate
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'radioGroupField') {
        aditionalProps = {
          initialValue: object[fieldId],
          options: fieldInfo.options
        };
        return (
          <FormFieldRadioGroup
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'checkboxGroupField') {
        aditionalProps = {
          initialValue: object[fieldId].map((value) => {
            return value.id;
          }),
          columns: fieldInfo.columns ? fieldInfo.columns : 1,
          options: fieldInfo.options
        };
        return (
          <FormFieldCheckboxGroup
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'select') {
        aditionalProps = {
          initialValue: {value: object[id], label: object[fieldId]},
          getOptions: fieldInfo.getOptions
        }
        return (
          <FormFieldSelect
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else {
        return null;
      }
    }
  }
}
