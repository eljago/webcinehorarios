'use strict'

import React from 'react';
import _ from 'lodash';

import FormFieldText from '../FormFields/FormFieldText'
import FormFieldImage from '../FormFields/FormFieldImage'
import FormFieldCheckbox from '../FormFields/FormFieldCheckbox'
import FormFieldCheckboxGroup from '../FormFields/FormFieldCheckboxGroup'
import FormFieldRadioGroup from '../FormFields/FormFieldRadioGroup'
import FormFieldSelect from '../FormFields/FormFieldSelect'
import FormFieldNested from '../FormFields/FormFieldNested'
import FormFieldHidden from '../FormFields/FormFieldHidden'

import Button from 'react-bootstrap/lib/Button';

export default class FormBuilder {
  constructor(schema, object) {
    this.schema = schema;
    this.object = object;
    this.nestedFormBuilder = {};

    for (const fieldKey in this.schema) {
      const fieldData = this.schema[fieldKey];
      if (fieldData.type === 'nested') {
        this.object[fieldKey] = _.isArray(this.object[fieldKey]) ? this.object[fieldKey] : [];
        this.nestedFormBuilder[fieldKey] = new FormBuilder(fieldData.nestedSchema, this.object[fieldKey]);
      }
    }
  }

  getNestedField(primaryFieldId, secondaryFieldId, index, options = {}) {
    if (primaryFieldId && secondaryFieldId && this.nestedFormBuilder && this.nestedFormBuilder[primaryFieldId]) {
      const fb = this.nestedFormBuilder[primaryFieldId];

      const object = (index < fb.object.length) ? fb.object[index] : this.schema[primaryFieldId].defaultObject;
      const secondaryFieldData = this.schema[primaryFieldId].nestedSchema[secondaryFieldId];
      return fb.getField(secondaryFieldId, {
        ...options,
        initialValue: options.getInitialValue ? options.getInitialValue(object) : object[secondaryFieldId],
        ref: options.ref ? options.ref : `${secondaryFieldId}_${index}`,
        identifier: `${secondaryFieldId}_${index}`,
        label: options.label ? options.label : secondaryFieldData.label,
      });
    }
    return null;
  }

  getField(fieldId, options = {}) {
    if (this.schema && fieldId && this.schema[fieldId]) {
      const fieldData = this.schema[fieldId];
      let elementData = {
        submitKey: fieldData.submitKey ? fieldData.submitKey : fieldId,
        label: fieldData.label,
        ref: fieldId,
        identifier: fieldId,
        initialValue: this.object[fieldId],
        ...options
      };
      let Component = FormFieldText;
      switch(fieldData.type) {
        case 'image':
          Component = FormFieldImage
          break;
        case 'checkbox':
          Component = FormFieldCheckbox;
          break;
        case 'checkboxGroup':
          elementData.options = fieldData.options;
          Component = FormFieldCheckboxGroup;
          break;
        case 'radioGroup':
          elementData.options = fieldData.options;
          Component = FormFieldRadioGroup;
          break;
        case 'number':
          elementData.type = 'number';
          break;
        case 'textarea':
          elementData.type = 'textarea';
          break;
        case 'hidden':
          Component = FormFieldHidden;
          break;
        case 'nested':
          elementData.dataKeys = Object.keys(fieldData.nestedSchema);
          Component = FormFieldNested;
          break;
        case 'select':
          elementData.options = fieldData.options;
          elementData.getOptions = fieldData.getOptions;
          elementData.async = fieldData.async;
          Component = FormFieldSelect;
          break;
        default:
          elementData.type = 'text';
      }
      return(
        <Component {...elementData} />
      );
    }
    return null
  }

  getDeleteButton(options) {
    if (this.schema && this.schema['delete']) {
      const fieldData = this.schema['delete'];
      const alertMsg = fieldData.alertMessage ? fieldData.alertMessage : '¿Eliminar?';
      return(
        <Button
          bsStyle="danger"
          onClick={(e) => {
            if (confirm(fieldData.alertMessage)) {
              fieldData.onDelete();
            }
            e.preventDefault();
          }}
          {...options}
        >
          {options.disabled ? '...' : (options.text ? options.text : 'Eliminar')}
        </Button>
      );
    }
    return null;
  }

  getSubmitButton(options) {
    if (this.schema && this.schema['submit']) {
      return(
        <Button
          bsStyle="primary"
          type="submit"
          onClick={(e) => {
            this.schema['submit'].onSubmit();
            e.preventDefault();
          }}
          {...options}
        >
          {options.disabled ? '...' : (options.text ? options.text : 'Submit')}
        </Button>
      );
    }
    return null;
  }
}


