'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';


export default class FormCast extends React.Component {
  static propTypes = {
    show_person_roles: PropTypes.array,
    getShowPersonRolesOptions: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      images: props.show_person_roles.map((spr) => {
        return spr.image.smallest.url;
      })
    }
    _.bindAll(this, ['_onAddItem', '_onDeleteItem'])
  }

  render() {
    return(
      <FormFieldNested
        ref='show_person_roles_attributes'
        submitKey='show_person_roles_attributes'
        label='Elenco'
        initialDataArray={this.props.show_person_roles}
        onAddItem={this._onAddItem}
        onDeleteItem={this._onDeleteItem}
        dataKeys={['person_id', 'character', 'director', 'actor']}
        getContentRow={(spr, index) => {

          return(
            <Row>
              <Col xs={12} md={1}>
                <Image
                  style={{width: 80, height: 100, "objectFit": 'cover'}}
                  src={this.state.images[index]}
                  responsive
                />
              </Col>
              <Col xs={12} md={4}>
                <FormFieldSelect
                  submitKey='person_id'
                  label='Elenco'
                  ref={`person_id${index}`}
                  initialValue={{
                    value: spr.person_id,
                    label: spr.name
                  }}
                  getOptions={this.props.getShowPersonRolesOptions}
                  onChange={(newValue) => {
                    this._onChangeSelect(newValue, index);
                  }}
                />
              </Col>
              <Col xs={12} md={4}>
                <FormFieldText
                  submitKey='character'
                  label='Personaje'
                  ref={`character${index}`}
                  initialValue={spr.character}
                />
              </Col>
              <Col xs={6} md={1}>
                <FormFieldCheckbox
                  submitKey='actor'
                  label='Actor'
                  ref={`actor${index}`}
                  initialValue={spr.id ? spr.actor : true}
                />
              </Col>
              <Col xs={6} md={1}>
                <FormFieldCheckbox
                  submitKey='director'
                  label='Director'
                  ref={`director${index}`}
                  initialValue={spr.director}
                />
              </Col>
            </Row>
          );
        }}
      />
    );
  }

  _onChangeSelect(value, index) {
    this.setState({
      images: update(this.state.images, {[index]: {$set: value.image_url}})
    });
  }

  _onAddItem(newItem) {
    this.setState({
      images: update(this.state.images, {$push: ['/uploads/default_images/default.png']})
    });
  }

  _onDeleteItem(index) {
    this.setState({
      images: update(this.state.images, {$splice: [[index, 1]]})
    });
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