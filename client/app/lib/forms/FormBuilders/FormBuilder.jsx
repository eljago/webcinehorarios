'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldText from '../FormFields/FormFieldText'
import FormFieldImage from '../FormFields/FormFieldImage'
import FormFieldSelect from '../FormFields/FormFieldSelect'
import FormFieldSelectWithImage from '../FormFields/FormFieldSelectWithImage'
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

  getFormField(schemaPath, options = {}) {
    if (_.has(this.schema, schemaPath)) {
      const fieldInfo = _.get(this.schema, schemaPath);
      const fieldType = fieldInfo.fieldType;
      const fieldId = _.last(schemaPath.split('.'));
      let initialValuePath = fieldInfo.initialValuePath;
      if (_.isNumber(options.index)) {
        initialValuePath = initialValuePath.replace(/\[\]/, `[${options.index}]`);
      }

      const formFieldProps = {
        fieldId: fieldId,
        formBuilder: this,
        ref: initialValuePath,
        submitKey: fieldInfo.submitKey ? fieldInfo.submitKey : fieldId,
        label: fieldInfo.label
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
          initialValue: _.get(this.object, initialValuePath),
          setThumbSource: options.setThumbSource
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
        const selectFieldsPaths = fieldInfo.selectFieldsPaths;
        const initialValue = _.mapValues(selectFieldsPaths, (valuePath) => {
          const pathWithIndex = valuePath.replace(/\[\]/, `[${options.index}]`);
          return _.get(this.object, pathWithIndex);
        });
        aditionalProps = {
          initialValue: initialValue,
          getOptions: fieldInfo.getOptions,
        };
        return (
          <FormFieldSelect
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'selectWithImageField') {
        const selectFieldsPaths = fieldInfo.selectFieldsPaths;
        const initialValue = _.mapValues(selectFieldsPaths, (valuePath) => {
          const pathWithIndex = valuePath.replace(/\[\]/, `[${options.index}]`);
          return _.get(this.object, pathWithIndex);
        });
        aditionalProps = {
          initialValue: initialValue,
          getOptions: fieldInfo.getOptions,
        };
        return (
          <FormFieldSelectWithImage
            {...formFieldProps}
            {...aditionalProps}
          />
        );
      }
      else if (fieldType === 'hasManyDynamic') {
        return (
          <FormFieldHasManyDynamic
            {...formFieldProps}
          />
        );
      }
    }
    return null;
  }
}
