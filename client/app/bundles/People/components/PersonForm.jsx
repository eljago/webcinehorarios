'use strict';

import React, { PropTypes } from 'react'

import Image from 'react-bootstrap/lib/Image';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Button from 'react-bootstrap/lib/Button';

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages';

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class PersonForm extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    submitting: PropTypes.bool,
    errors: PropTypes.object,
    onClose: PropTypes.func,
    submitting: PropTypes.bool,
  };

  constructor(props) {
    super(props);
    this.state = {
      personThumb: '',
    };
  }

  render() {
    const {formBuilder, submitting, onClose} = this.props;
    return (
      <div>
        <ErrorMessages errors={this.props.errors} />
        <Row>
          <Col xs={12} sm={4}>
            <Image src={this.state.personThumb} responsive/>
          </Col>
          <Col xs={12} sm={8}>
            <form>
              {formBuilder.getField('name', {disabled: submitting})}
              {formBuilder.getField('imdb_code', {disabled: submitting})}
              {formBuilder.getField('image', {
                initialValue: formBuilder.object.image.small.url,
                disabled: submitting,
                onChange: (personThumb) => {this.setState({personThumb})}
              })}
              {formBuilder.getSubmitButton({
                disabled: submitting
              })}
              {this._getDeleteButton()}
              <Button
                onClick={onClose}
                block
              >
                Cancelar
              </Button>
            </form>
          </Col>
        </Row>
      </div>
    );
  }

  _getDeleteButton() {
    if (this.props.formBuilder.object.id) {
      return this.props.formBuilder.getDeleteButton({
        disabled: this.props.submitting
      });
    }
    return null;
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}
