'use strict';

import React, { PropTypes } from 'react'
import update from 'react/lib/update';
import _ from 'lodash'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Button from 'react-bootstrap/lib/Button';

import FormFieldSelect from '../../../lib/forms/FormFields/FormFieldSelect';

export default class ParsedShowsRow extends React.Component {
  static propTypes = {
    parsedShow: PropTypes.object,
    getShowsOptions: PropTypes.func,
    updateRow: PropTypes.func,
    deleteRow: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      parsedShow: props.parsedShow,
      submitting: false,
    };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({parsedShow: nextProps.parsedShow})
  }

  render() {
    const {parsedShow, submitting} = this.state;
    return (
      <Row>
        <Col 
          style={{marginTop: 24, marginBottom: 24}}
          xs={12} 
          md={3}
        >
          <span
            style={{fontSize: 16, fontWeight: 600}}
          >
            {parsedShow.name}
          </span>
        </Col>
        <Col xs={12} md={4}>
          <FormFieldSelect
            submitKey='show_id'
            label='Show'
            ref={'show_id'}
            initialValue={{
              value: parsedShow.show_id,
              label: parsedShow.show_name
            }}
            getOptions={this.props.getShowsOptions}
            onChange={(newValue) => {this._onChangeSelect(newValue)}}
          />
        </Col>
        <Col xs={12} md={2}>
          <Button
            style={{marginTop: 24}}
            bsStyle="success"
            block
            disabled={submitting}
            onClick={() => {
              if (!submitting) {
                this._onUpdateRow();
              }
            }}
          >
            {submitting ? 'Busy...' : 'Actualizar'}
          </Button>
          <Button
            bsStyle="danger"
            block
            disabled={submitting}
            onClick={() => {
              if (!submitting) {
                this._onDeleteRow();
              }
            }}
          >
            {submitting ? 'Busy...' : 'Eliminar'}
          </Button>
        </Col>
      </Row>
    );
  }
  
  _onChangeSelect(selectData) {
    this.setState({
      parsedShow: update(this.state.parsedShow, {show_id: {$set: selectData.value}})
    });
  }

  _onUpdateRow() {
    this.setState({submitting: true});
    // SUBMIT / UPDATE
    this.props.updateRow(this.state.parsedShow, () => { // Callback
      this.setState({submitting: false});
    });
  }

  _onDeleteRow() {
    if (confirm(`¿Borrar Parsed Show ${this.state.parsedShow.name}?`)) {
      this.setState({submitting: true});
      this.props.deleteRow(this.state.parsedShow.id, () => { // Callback
        this.setState({submitting: false});
      });
    }
  }
}
