'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';

export default class FormFieldFile extends React.Component {
  static propTypes = {
    controlId: PropTypes.string,
    onChange: PropTypes.func,
  };

  constructor(props) {
    super(props)
    _.bindAll(this, '_handleChange');
  }

  render() {
    return(
      <FormGroup
        controlId={this.props.controlId}
      >
        <ControlLabel>Local Image</ControlLabel>
        <FormControl
          type="file"
          onChange={this._handleChange}
          multiple={false}
        />
      </FormGroup>
    );
  }

  _handleChange(e) {
    const {onChange, controlId} = this.props;

    let file = e.target.files[0]
    let reader = new FileReader()

    if (file) {
      reader.readAsDataURL(file)

      reader.onload = () => {
        if (validator.isDataURI(reader.result)) {
          const dataTypeArray = file.type.split("/");
          if (
            dataTypeArray[0] === 'image'
            &&
            ["jpg","jpeg","gif","png"].includes(dataTypeArray[1])
            &&
            validator.isBase64(reader.result.split(',')[1])
          ) {
            onChange(controlId, reader.result);
          }
        }
      }
    }
    else {
      onChange(controlId, '');
      return false;
    }
  }
}
