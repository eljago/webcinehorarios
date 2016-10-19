'use strict';

import React, { PropTypes } from 'react'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FormRow extends React.Component {

  static propTypes = {
    show: PropTypes.object,
    functionTypes: PropTypes.array,
  };
  static defaultProps = {
    show: {}
  }

  render() {
    const show = this.props.show;
    return(
      <Row style={{marginBottom: 5}}>
        <Col xs={2}>
          <img style={{width: 60, height: 80}}src={`http://cinehorarios.cl${show.image_url}`} />
        </Col>
        <Col xs={10}>
          {this._getFunctions()}
        </Col>
      </Row>
    );
  }

  _getFunctions() {
    if (!this.props.show.functions) return null;

    return this.props.show.functions.map((func) => {
      return (
        <Row style={styles.funcRow}>
          <Col xs={12} sm={4}>
            <span style={styles.span}>{this._getFunctionTypes(func)}</span>
          </Col>
          <Col xs={12} sm={8}>
            <span style={styles.span}>{func.showtimes}</span>
          </Col>
        </Row>
      );
    });
  }

  _getFunctionTypes(func) {
    let ftsNames = [];
    for (const ftId of func.function_types) {
      for (const ft of this.props.functionTypes) {
        if (ftId == ft.value) {
          ftsNames.push(ft.label);
          break;
        }
      }
    }
    return ftsNames.join(', ');
  }
}

const styles = {
  funcRow: {
    marginBottom: 5,
  },
  span: {
    fontSize: 18
  }
}