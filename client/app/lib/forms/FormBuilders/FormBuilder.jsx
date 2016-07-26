'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldText from '../FormFields/FormFieldText'
import FormFieldFile from '../FormFields/FormFieldFile'
import FormFieldSelect from '../FormFields/FormFieldSelect'
import FormFieldDate from '../FormFields/FormFieldDate'
import FormFieldRadioGroup from '../FormFields/FormFieldRadioGroup'
import FormFieldCheckboxGroup from '../FormFields/FormFieldCheckboxGroup'
import FormFieldHasManyDynamic from '../FormFields/FormFieldHasManyDynamic'

export default class FormBuilder {

  constructor(object, schema) {
    this.object = object;
    this.schema = schema;
  }

  getFormField(schemaPath, objectPath = null) {
    if (_.has(this.schema, schemaPath)) {
      const fieldInfo = _.get(this.schema, schemaPath);
      const fieldType = fieldInfo.fieldType;
      const fieldId = schemaPath.split('.')[0];
      const objPath = objectPath ? objectPath : fieldId;

      const formFieldProps = {
        submitKey: fieldInfo.submitKey ? fieldInfo.submitKey : fieldId,
        label: fieldInfo.label,
      }
      let aditionalProps;

      if (fieldType === 'textField') {
        if (fieldInfo.textFieldType === 'number') {
          aditionalProps = {
            type: 'number',
            regExp: fieldInfo.regExp,
            initialValue: _.get(this.object, objPath)
          };
        }
        else if (fieldInfo.textFieldType === 'textarea') {
          aditionalProps = {
            type: 'textarea',
            initialValue: _.get(this.object, objPath)
          };
        }
        else {
          aditionalProps = {
            type: 'text',
            regExp: fieldInfo.regExp,
            initialValue: _.get(this.object, objPath)
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
          initialValue: _.get(this.object, objPath)
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
          initialValue: _.get(this.object, objPath),
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
          initialValue: _.get(this.object, objPath).map((value) => {
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
      else if (fieldType === 'selectField') {
        aditionalProps = {
          initialValue: {
            value: _.get(this.object, "id"),
            label: _.get(this.object, objPath)
          },
          getOptions: fieldInfo.getOptions,
        }
        return (
          <FormFieldSelect
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'hasManyDynamic') {
        aditionalProps = {
          fieldId: fieldId,
          formBuilder: this,
        }
        return (
          <FormFieldHasManyDynamic
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
    }
    return null;
  }
}
