'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText';
import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage';

export default class PersonForm extends React.Component {
  static propTypes = {
    person: PropTypes.object,
    onSubmit: PropTypes.func,
    onClose: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
      personThumb: '',
    };
    _.bindAll(this, '_onSubmit');
  }

  render() {
    const person = this.props.person;
    return (
      <Row>
        <Col xs={12} sm={4}>
          <Image src={this.state.personThumb} responsive/>
        </Col>
        <Col xs={12} sm={8}>
          <form>
            <FormFieldText
              submitKey='name'
              ref='name'
              initialValue={person ? person.name : ''}
              disabled={this.state.submitting}
            />
            <FormFieldText
              submitKey='imdb_code'
              ref='imdbCode'
              initialValue={person ? person.imdb_code : ''}
              disabled={this.state.submitting}
            />
            <FormFieldImage
              onChange={(personThumb) => this.setState({personThumb})}
              initialValue={person && person.image ? person.image.small.url : ''}
              ref='image'
              disabled={this.state.submitting}
            />
            <Button
              type="submit"
              disabled={this.state.submitting}
              onClick={this._onSubmit}>
              Submit
            </Button>
          </form>
        </Col>
      </Row>
    );
  }

  _onSubmit(e) {
    const personId = this.props.person.id ? {id: this.props.person.id} : null;
    const personResult = _.merge(this.props.person, {
      ...personId,
      ...this.refs.name.getResult(),
      ...this.refs.imdbCode.getResult(),
      ...this.refs.image.getResult()
    });
    console.log(personResult);

    this.setState({submitting: true});
    this.props.onSubmit(personResult, (result, errors = null) => {
      this.setState({submitting: false});
      console.log(result);
      if (result) {
        this.props.onClose();
      }
      else {

      }
    });
    e.preventDefault();
  }
}
