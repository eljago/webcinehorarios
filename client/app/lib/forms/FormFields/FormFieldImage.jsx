'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import Thumbnail from 'react-bootstrap/lib/Thumbnail';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormFieldFile extends React.Component {
  static propTypes = {
    submitKey: PropTypes.string,
    submitKeyRemoteImage: PropTypes.string,
    submitKeyLocalImage: PropTypes.string,
    label: PropTypes.string,
    initalValue: PropTypes.string,
  };

  constructor(props) {
    super(props);
    this.state = {
      currentRemote: '',
      currentLocal: '',
      submitValue: this.props.initalValue
    }
    _.bindAll(this, ['_handleChangeRemote', '_handleChangeLocal']);
  }

  render() {
    // let image_url = _.get(this.object, objPath);
    // let smallest_image_url = image_url.replace(/(\w+\.\w+)$/, "smallest_$1");
    // smallest_image_url = `http://cinehorarios.cl${smallest_image_url}`;
    return(
      <FormGroup controlId={this.props.submitKeyRemoteImage}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <Row>
          <Col xs={2}>
            <Thumbnail
              src={this.state.submitValue}
              responsive
            />
          </Col>
          <Col xs={5}>
            <FormControl
              value={this.state.currentRemote}
              placeholder='Remote Image'
              onChange={(e) => {
                this._handleChangeRemote(_.replace(e.target.value,'  ', ' '))
              }}
            />
          </Col>
          <Col xs={5}>
            <FormControl
              type="file"
              onChange={this._handleChangeLocal}
              multiple={false}
            />
          </Col>
        </Row>
      </FormGroup>
    );
  }

  _handleChangeRemote(value) {
    if (validator.isURL(value) || validator.matches(value, /^.+\.(png|jpg|jpeg|gif)$/)) {
      this.setState({
        currentRemote: value,
        currentLocal: '',
        submitValue: value
      });
    }
    else {
      this.setState({
        currentRemote: ''
      });
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
            this.setState({
              currentLocal: reader.result,
              currentRemote: '',
              submitValue: reader.result
            });
          }
          else {
            this.setState({
              currentLocal: ''
            });
          }
        }
        else {
          this.setState({
            currentLocal: ''
          });
        }
      }
    }
    else {
      return false;
    }
  }

  getResult() {
    if (!_.isEmpty(this.state.currentRemote)) {
      return {remote_image_url: this.state.submitValue};
    }
    else if (!_.isEmpty(this.state.currentLocal)) {
      return {image: this.state.submitValue};
    }
    return null;
  }
}
