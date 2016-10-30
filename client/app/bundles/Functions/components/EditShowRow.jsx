'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import FormBuilder from '../../../lib/forms/FormBuilder';

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class EditFormRow extends React.Component {

  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    offsetDays: PropTypes.number,
    theaterId: PropTypes.number,
  };

  constructor(props) {
    super(props);
    _.bindAll(this, '_getContentRow');
  }

  render() {
    const formBuilder = this.props.formBuilder;
    const show = formBuilder.object;
    return(
      <Row>
        <Col xs={12} sm={3} md={2}>
          <img src={`http://cinehorarios.cl${show.image_url}`} />
        </Col>
        <Col xs={12} sm={9} md={10}>
          {formBuilder.getField('functions', {
            getContentRow: this._getContentRow
          })}
        </Col>
      </Row>
    );
  }
  
  _getContentRow(func, index) {
    const formBuilder = this.props.formBuilder;
    return(
      <Row key={func.id ? func.id : func.key}>
        <Col xs={12} sm={func.id ? 5 : 2}>
          {formBuilder.getNestedField('functions', 'function_types', index, {
            columns: func.id ? 3 : 1
          })}
        </Col>
        <Col xs={12} sm={func.id ? 7 : 10}>
          {(() => {
            if (func.id) {
              return formBuilder.getNestedField('functions', 'showtimes', index);
            }
            else {
              let extraFields = [];
              for (var i = 0; i < 7; i++) {
                extraFields.push(formBuilder.getNestedField('functions', 'showtimes', index, {
                  label: _.upperFirst(moment().add(this.props.offsetDays + i, 'days').format('ddd DD')),
                  ref: `showtimes_${index}_${i}`,
                  horizontal: true,
                }));
                extraFields.push(formBuilder.getNestedField('functions', 'date', index, {
                  getInitialValue: (obj) => {
                    return moment().add(this.props.offsetDays + i, 'days').format('YYYY-MM-DD');
                  },
                  ref: `date_${index}_${i}`,
                }));
                extraFields.push(formBuilder.getNestedField('functions', 'theater_id', index, {
                  getInitialValue: (obj) => {
                    return this.props.theaterId;
                  },
                  ref: `theater_id_${index}_${i}`,
                }));
              }
              return extraFields;
            }
          })()}
        </Col>
      </Row>
    );
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });

    if (showResult.functions_attributes) {
      for (let i = showResult.functions_attributes.length - 1; i >= 0; i--) {
        let func = showResult.functions_attributes[i];
        if (!func.showtimes && !func.id) {
          showResult.functions_attributes.splice(i, 1);
        }
      }
    }
    if (!_.isEmpty(showResult)) {
      const functionsAttributes = [];
      showResult.functions_attributes.forEach((func) => {
        functionsAttributes.push(func);
      })
      return functionsAttributes;
    }
    else {
      return null;
    }
  }
}