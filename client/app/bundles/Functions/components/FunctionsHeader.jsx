'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class FunctionsHeader extends React.Component {
  static propTypes = {
    title: PropTypes.string,
    subtitle: PropTypes.string,
    editing: PropTypes.boolean,
    onChangeEditing: PropTypes.func,
    onCopyDay: PropTypes.func,
    onDeleteDay: PropTypes.func,
    onDeleteOnward: PropTypes.func,
    disabled: PropTypes.boolean,
  };
  static defaultProps = {
    editing: false,
    disabled: false,
  }

  render() {
    return (
      <div style={{display: 'flex', flexDirection: 'row', marginBottom: 10}}>
        <span style={{flex: 1, fontSize: 26}}>
          {this.props.title}
        </span>
        <span style={{flex: 1, color: 'gray', fontSize: 22}}>
          {this.props.subtitle}
        </span>
        <button
          style={styles.button}
          className={`btn btn-primary`}
          onClick={(e) => {
            this.props.onCopyDay();
          }}
          disabled={this.props.disabled}
        >
          Copiar Día
        </button>
        <button
          style={styles.button}
          className={`btn btn-danger`}
          onClick={(e) => {
            this.props.onDeleteDay();
          }}
          disabled={this.props.disabled}
        >
          Borrar Día
        </button>
        <button
          style={styles.button}
          className={`btn btn-danger`}
          onClick={(e) => {
            this.props.onDeleteOnward();
          }}
          disabled={this.props.disabled}
        >
          Borrar desde Hoy
        </button>
        <button
          style={styles.button}
          className={`btn btn-${!this.props.editing ? "warning" : "danger"}`}
          onClick={(e) => {
            this.props.onChangeEditing();
          }}
          disabled={this.props.disabled}
        >
          {!this.props.editing ? "Editar" : "Cancel"}
        </button>
      </div>
    );
  }
}

const styles = {
  button: {
    marginLeft: 5,
  }
}