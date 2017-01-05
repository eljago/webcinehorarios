'use strict';

import React, { PropTypes } from 'react'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FunctionsRow extends React.Component {

  static propTypes = {
    functionsContainer: PropTypes.object,
    functionTypes: PropTypes.array,
    style: PropTypes.object,
  };
  static defaultProps = {
    functionsContainer: {}
  }

  render() {
    const functionsContainer = this.props.functionsContainer;
    return(
      <tr>
        <td>
          <img style={{width: 60, height: 80}} src={`http://cinehorarios.cl${functionsContainer.image_url}`} />
        </td>
        <td>
          <span style={styles.fontSize}>{functionsContainer.name}</span>
        </td>
        <td>
          {this._getFunctionsRows()}
        </td>
      </tr>
    );
  }

  _getFunctionsRows() {
    if (!this.props.functionsContainer.functions) return null;

    return this.props.functionsContainer.functions.map((func) => {
      return (
        <Row key={func.id}>
          <Col xs={12} sm={4}>
            <span style={styles.fontSize}>{func.parsed_show ? func.parsed_show.name : null}</span>
          </Col>
          <Col xs={12} sm={3}>
            <span style={styles.fontSize}>{this._getFunctionTypes(func)}</span>
          </Col>
          <Col xs={12} sm={5}>
            <span style={styles.fontSize}>{func.showtimes}</span>
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
  fontSize: {
    fontSize: 18,
  }
}