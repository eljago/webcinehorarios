'use strict'

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Select from 'react-select';

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import {SelectQueries} from '../../../lib/api/queries'

export default class AddShow extends React.Component {

  static propTypes = {
    onShowAdded: PropTypes.func,
    disabled: PropTypes.boolean,
  };
  static defaultProps = {
    disabled: false,
  };

  constructor(props) {
    super(props);
    this.state = {
      currentShow: null,
    }
    _.bindAll(this, ['_handleClick', '_handleChange'])
  }

  render() {
    return (
      <Row style={{marginBottom: 10}}>
        <Col xs={12} sm={5}>
          <Select.Async
            name='Shows'
            value={this.state.currentShow}
            onChange={this._handleChange}
            loadOptions={SelectQueries.getShowsOptions}
            clearable={false}
            cache={false}
          />
        </Col>
        <Col xs={12} sm={2}>
          <button
            className="btn btn-primary"
            disabled={this.props.disabled}
            onClick={this._handleClick}
          >
            Agregar Show
          </button>
        </Col>
      </Row>
    );
  }

  _handleChange(newShow) {
    this.setState({currentShow: newShow});
  }

  _handleClick(e) {
    if (_.isFunction(this.props.onShowAdded)) {
      this.props.onShowAdded(this.state.currentShow);
    }
    e.preventDefault();
  }
}