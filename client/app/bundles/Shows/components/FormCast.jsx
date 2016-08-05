'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldNested from '../../../lib/forms/FormFields/FormFieldNested'
import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect'
import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
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
      images: this.props.show_person_roles.map((spr) => {
        return spr.image.smallest.url;
      })
    }
    _.bindAll(this, '_onDataArrayChanged')
  }

  render() {
    return(
      <FormFieldNested
        ref='show_person_roles_attributes'
        submitKey='show_person_roles_attributes'
        label='Elenco'
        initialDataArray={this.props.show_person_roles}
        onDataArrayChanged={this._onDataArrayChanged}
        dataKeys={['person_id']}
        getRowCols={(spr, index) => {
          const imageSource = this.state.images[index] ?
            `http://cinehorarios.cl${this.state.images[index]}` :
            'http://cinehorarios.cl/uploads/default_images/default.png';

          return([
              <Col md={1}>
                <Image
                  style={{width: 80, height: 100, "objectFit": 'cover'}}
                  src={imageSource}
                  responsive
                />
              </Col>,
              <Col md={4}>
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
              </Col>,
              <Col md={4}>
                <FormFieldText
                  submitKey='character'
                  label='Personaje'
                  ref={`character${index}`}
                  initialValue={spr.character}
                />
              </Col>
            ]
          );
        }}
      />
    );
  }

  _onChangeSelect(value, index) {
    let images = this.state.images;
    images[index] = value.image_url;
    this.setState({images});
  }

  _onDataArrayChanged(dataArray) {
    this.setState({
      images: dataArray.map((dataItem) => {
        if (dataItem.image) {
          return dataItem.image.smallest.url;
        }
        return null;
      })
    })
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement, key) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}