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
      <tr>
        <td>
          <img src={`http://cinehorarios.cl${show.image_url}`} />
        </td>
        <td>
          {formBuilder.getField('functions', {
            getContentRow: this._getContentRow
          })}
        </td>
      </tr>
    );
  }
  
  _getContentRow(func, index) {
    const formBuilder = this.props.formBuilder;
    return(
      <Row key={func.id ? func.id : func.key}>
        <Col xs={12} md={5}>
          {formBuilder.getNestedField('functions', 'function_types', index, {
            columns: 3
          })}
        </Col>
        <Col xs={12} md={7}>
          {(() => {
            if (func.id) {
              return formBuilder.getNestedField('functions', 'showtimes', index);
            }
            else {
              let extraFields = [];
              for (var i = 0; i < 7; i++) {
                extraFields.push(formBuilder.getNestedField('functions', 'showtimes', index, {
                  label: moment().add(this.props.offsetDays + i, 'days').format('dddd D [de] MMMM, YYYY'),
                  ref: `showtimes_${index}_${i}`,
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