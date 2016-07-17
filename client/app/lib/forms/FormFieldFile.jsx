import React, { PropTypes } from 'react';
import _ from 'lodash';
import {FormGroup, FormControl} from 'react-bootstrap'
import validator from 'validator';

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
        <FormControl
          type="file"
          onChange={ this._handleChange }
          multiple={ false } 
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
    }

  }
}
