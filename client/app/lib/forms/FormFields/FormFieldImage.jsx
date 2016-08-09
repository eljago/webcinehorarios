'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';

export default class FormFieldImage extends React.Component {
  static propTypes = {
    onChange: PropTypes.func,
    initialValue: PropTypes.string
  };

  constructor(props) {
    super(props);
    this.state = {
      currentRemote: '',
      currentLocal: ''
    }
    _.bindAll(this, ['_handleChangeRemote', '_handleChangeLocal']);
  }

  componentDidMount() {
    this._setStateAndOnChange('', '');
  }

  render() {
    return(
      <FormGroup controlId={(new Date()).getTime()}>
        <ControlLabel>Remote Image URL</ControlLabel>
        <FormControl
          value={this.props.currentRemote}
          placeholder='Remote Image'
          onChange={(e) => {
            this._handleChangeRemote(_.replace(e.target.value,'  ', ' '))
          }}
        />
        <br />
        <ControlLabel>Local Image</ControlLabel>
        <FormControl
          type="file"
          onChange={this._handleChangeLocal}
          multiple={false}
        />
      </FormGroup>
    );
  }

  _handleChangeRemote(value) {
    if (validator.isURL(value)) {
      this._setStateAndOnChange(value, '');
    }
    else {
      this._setStateAndOnChange('', '');
    }
  }

  _setStateAndOnChange(remoteImageUrl, localImage) {
    this.setState({
      currentRemote: remoteImageUrl,
      currentLocal: localImage
    });
    this.props.onChange(!_.isEmpty(remoteImageUrl) ? remoteImageUrl :
      (!_.isEmpty(localImage) ? localImage :
        (!_.isEmpty(this.props.initialValue) ? this.props.initialValue :
          '/uploads/default_images/default.png'
        )
      )
    );
  }

  _handleChangeLocal(e) {
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
            this._setStateAndOnChange('', reader.result);
          }
          else {
            this._setStateAndOnChange('', '');
          }
        }
        else {
          this._setStateAndOnChange('', '');
        }
      }
    }
    else {
      return false;
    }
  }

  getResult() {
    if (!_.isEmpty(this.state.currentRemote)) {
      return {remote_image_url: this.state.currentRemote};
    }
    else if (!_.isEmpty(this.state.currentLocal)) {
      return {image: this.state.currentLocal};
    }
    return null;
  }
}
