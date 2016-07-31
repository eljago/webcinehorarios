'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import validator from 'validator';

import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import ControlLabel from 'react-bootstrap/lib/ControlLabel';
import Image from 'react-bootstrap/lib/Image';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormBuilder from '../FormBuilders/FormBuilder'

export default class FormFieldFile extends React.Component {
  static propTypes = {
    fieldId: PropTypes.string,
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitKey: PropTypes.string,
    label: PropTypes.string,
    initialValue: PropTypes.string,
    setThumbSource: PropTypes.func,
  };
  static defaultProps = {
    initialValue: ''
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
    this.props.setThumbSource(this.props.initialValue)
  }

  render() {
    return(
      <FormGroup controlId={this.props.submitKey}>
        <ControlLabel>{this.props.label}</ControlLabel>
        <Row>
          {this._getThumbnailElement()}
          <Col md={this.props.setThumbSource ? 12 : 8}>
            <FormControl
              value={this.props.currentRemote}
              placeholder='Remote Image'
              onChange={(e) => {
                this._handleChangeRemote(_.replace(e.target.value,'  ', ' '))
              }}
            />
            <br />
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

  _getThumbnailElement() {
    if (this.props.setThumbSource) {
      return null
    }
    else {
      const {currentRemote, currentLocal} = this.state;
      let thumb = this.props.initialValue;
      if (currentRemote !== '') {
        thumb = currentRemote;
      }
      else if (currentLocal !== '') {
        thumb = currentLocal;
      }
      return (
        <Col md={4}>
          <Image
            src={thumb !== '' ? thumb : '/uploads/default_images/default.png'}
            responsive
          />
        </Col>
      );
    }
  }

  _handleChangeRemote(value) {
    if (validator.isURL(value)) {
      $.get(value).done(() => {
        this.setState({
          currentRemote: value,
          currentLocal: ''
        });
        this.props.setThumbSource(value);
      }).fail(() => {
        this.setState({
          currentRemote: '',
          currentLocal: ''
        });
        this.props.setThumbSource('');
      })
    }
    else {
      this.setState({
        currentRemote: '',
        currentLocal: ''
      });
      this.props.setThumbSource('');
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
              currentRemote: ''
            });
          }
          else {
            this.setState({
              currentRemote: '',
              currentLocal: ''
            });
          }
        }
        else {
          this.setState({
            currentRemote: '',
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
      return {remote_image_url: this.state.currentRemote};
    }
    else if (!_.isEmpty(this.state.currentLocal)) {
      return {image: this.state.currentLocal};
    }
    return null;
  }
}
