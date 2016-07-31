'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldText from '../FormFields/FormFieldText'
import FormFieldImage from '../FormFields/FormFieldImage'
import FormFieldSelect from '../FormFields/FormFieldSelect'
import FormFieldDate from '../FormFields/FormFieldDate'
import FormFieldRadioGroup from '../FormFields/FormFieldRadioGroup'
import FormFieldCheckboxGroup from '../FormFields/FormFieldCheckboxGroup'
import FormFieldHasManyDynamic from '../FormFields/FormFieldHasManyDynamic'
import FormFieldCheckbox from '../FormFields/FormFieldCheckbox'

export default class FormBuilder {

  constructor(object, schema) {
    this.object = object;
    this.schema = schema;
  }

  getFormField(schemaPath, index = null) {
    if (_.has(this.schema, schemaPath)) {
      const fieldInfo = _.get(this.schema, schemaPath);
      const fieldType = fieldInfo.fieldType;
      const fieldId = _.last(schemaPath.split('.'));
      let initialValuePath = fieldInfo.initialValuePath;
      if (_.isNumber(index)) {
        initialValuePath = initialValuePath.replace(/\[\]/, `[${index}]`);
      }

      const formFieldProps = {
        ref: initialValuePath,
        submitKey: fieldInfo.submitKey ? fieldInfo.submitKey : fieldId,
        label: fieldInfo.label,
        validations: fieldInfo.validations,
      }
      let aditionalProps;

      if (fieldType === 'textField') {
        if (fieldInfo.textFieldType === 'number') {
          aditionalProps = {
            type: 'number',
            initialValue: _.get(this.object, initialValuePath)
          };
        }
        else if (fieldInfo.textFieldType === 'textarea') {
          aditionalProps = {
            type: 'textarea',
            initialValue: _.get(this.object, initialValuePath)
          };
        }
        else {
          aditionalProps = {
            type: 'text',
            initialValue: _.get(this.object, initialValuePath)
          };
        }
        return (
          <FormFieldText
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'imageField') {
        aditionalProps = {
          initialValue: _.get(this.object, initialValuePath)
        };
        return (
          <FormFieldImage
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'dateField') {
        aditionalProps = {
          initialValue: _.get(this.object, initialValuePath)
        };
        return (
          <FormFieldDate
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'checkboxField') {
        aditionalProps = {
          initialValue: _.get(this.object, initialValuePath)
        };
        return(
          <FormFieldCheckbox
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'radioGroupField') {
        aditionalProps = {
          initialValue: _.get(this.object, initialValuePath),
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
          initialValue: _.get(this.object, initialValuePath).map((value) => {
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
            label: _.get(this.object, initialValuePath)
          },
          keyName: fieldInfo.keyName,
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
          formColumns: fieldInfo.formColumns
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
