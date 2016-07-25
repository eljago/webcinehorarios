'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';

export default class FormFieldFile extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    label: PropTypes.string,
  };

  constructor(props) {
    super(props);
    this.state = {currentValue: ''}
    _.bindAll(this, '_handleChange');
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <FormControl
          type="file"
          onChange={this._handleChange}
          multiple={false}
        />
      </FormGroup>
    );
  }

  _handleChange(e) {
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
            this.setState({currentValue: reader.result});
          }
        }
      }
    }
    else {
      return false;
    }
  }

  getResult() {
    if (!_.isEmpty(this.state.currentValue)) {
      let result = {}
      result[this.props.submitKey] = this.state.currentValue;
      return result;
    }
    return null;
  }
}
