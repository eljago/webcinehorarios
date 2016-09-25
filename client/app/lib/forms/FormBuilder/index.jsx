'use strict'

import React from 'react';

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import FormFieldCheckboxGroup from '../../../lib/forms/FormFields/FormFieldCheckboxGroup'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'
import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect'
import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'

import Button from 'react-bootstrap/lib/Button';

export default class FormBuilder {
  constructor(schema, object) {
    this.schema = schema;
    this.object = object;
    this.nestedFormBuilder = {};

    for (const fieldKey in this.schema) {
      const fieldData = this.schema[fieldKey];
      if (fieldData.type === 'nested') {
        this.nestedFormBuilder[fieldKey] = new FormBuilder(fieldData.nestedSchema, this.object[fieldKey]);
      }
    }
  }

  getNestedField(primaryFieldId, secondaryFieldId, options = null) {
    if (primaryFieldId && secondaryFieldId && this.nestedFormBuilder && this.nestedFormBuilder[primaryFieldId]) {
      const fb = this.nestedFormBuilder[primaryFieldId];
      if (options && !_.isUndefined(options.index)) {
        const object = options.index < fb.object.length ? fb.object[options.index] : this.schema[primaryFieldId].defaultObject;
        const initialValue = options.customInitialValue ? options.customInitialValue(object) : object[secondaryFieldId];
        return fb.getField(secondaryFieldId, {
          initialValue: initialValue,
          ref: `${secondaryFieldId}${options.index}`
        });
      }
    }
    return null;
  }

  getField(fieldId, options = null) {
    if (this.schema && fieldId && this.schema[fieldId]) {
      const fieldData = this.schema[fieldId];
      let elementData = {
        submitKey: fieldData.submitKey ? fieldData.submitKey : fieldId,
        label: fieldData.label,
        ref: (options && options.ref) ? options.ref : fieldId,
        initialValue: (options && options.initialValue) ? options.initialValue : this.object[fieldId],
      };
      let Component = FormFieldText;
      switch(fieldData.type) {
        case 'image':
          elementData.onChange = (options ? options.onChange : null);
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
        case 'nested':
          elementData.dataKeys = Object.keys(fieldData.nestedSchema);
          elementData.onAddItem = (options ? options.onAddItem : null);
          elementData.onDeleteItem = (options ? options.onDeleteItem : null);
          elementData.getContentRow = (options ? options.getContentRow : null);
          Component = FormFieldNested;
          break;
        case 'select':
          elementData.options = fieldData.options;
          elementData.getOptions = fieldData.getOptions;
          elementData.onChange = (options ? options.onChange : null);
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

  getDeleteButton(disabled) {
    if (this.schema && this.schema['delete']) {
      const fieldData = this.schema['delete'];
      const alertMsg = fieldData.alertMessage ? fieldData.alertMessage : '¿Eliminar?';
      return(
        <Button
          bsStyle="danger"
          disabled={disabled}
          onClick={() => {
            if (confirm(fieldData.alertMessage)) {
              fieldData.onDelete();
            }
          }}
          block
        >
          {disabled ? '...' : 'Eliminar'}
        </Button>
      );
    }
    return null;
  }

  getSubmitButton(disabled) {
    if (this.schema && this.schema['submit']) {
      const fieldData = this.schema['submit'];
      return(
        <Button
          bsStyle="primary"
          disabled={disabled}
          onClick={!disabled ? fieldData.onSubmit() : null}
          block
        >
          {disabled ? '...' : 'Submit'}
        </Button>
      );
    }
    return null;
  }
}


