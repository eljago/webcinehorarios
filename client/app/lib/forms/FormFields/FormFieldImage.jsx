'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

export default class FormFieldImage extends React.Component {
  static propTypes = {
    identifier: PropTypes.string,
    onChange: PropTypes.func,
    initialValue: PropTypes.string,
    disabled: PropTypes.boolean,
    horizontal: PropTypes.boolean
  };
  static defaultProps = {
    horizontal: false,
  }

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
    const {identifier, currentRemote, disabled, horizontal} = this.props;
    const colStyle = horizontal ? "col-xs-6" : "col-xs-12";
    return(
      <div className="row">
        <div className={`${colStyle} form-group`}>
          <label className='control-label' for={`${identifier}-remote`}>Remote Image URL</label>
          <input
            type="text"
            className="form-control"
            id={identifier}
            placeholder="Remote Image URL"
            value={currentRemote}
            disabled={disabled}
            onChange={(e) => {
              this._handleChangeRemote(_.replace(e.target.value,'  ', ' '))
            }}
          />
        </div>
        <div className={`${colStyle} form-group`}>
          <label className='control-label' for={`${identifier}-local`}>Local Image</label>
          <input
            type="file"
            className="form-control"
            id={`${identifier}-local`}
            disabled={disabled}
            multiple={false}
            onChange={this._handleChangeLocal}
          />
        </div>
      </div>
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
    if (this.props.onChange) {
      this.props.onChange(!_.isEmpty(remoteImageUrl) ? remoteImageUrl :
        (!_.isEmpty(localImage) ? localImage :
          (!_.isEmpty(this.props.initialValue) ? this.props.initialValue :
            '/uploads/default_images/default.png'
          )
        )
      );
    }
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
