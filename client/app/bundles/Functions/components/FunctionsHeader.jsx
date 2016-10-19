'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

export default class FunctionsHeader extends React.Component {
  static propTypes = {
    title: PropTypes.string,
    subtitle: PropTypes.string,
    editing: PropTypes.boolean,
    onChangeEditing: PropTypes.func,
  };
  static defaultProps = {
    editing: false,
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
          className={`btn btn-${!this.props.editing ? "warning" : "danger"}`}
          onClick={(e) => {
            this.props.onChangeEditing();
          }}
        >
          {!this.props.editing ? "Editar" : "Stop Editing"}
        </button>
      </div>
    );
  }
}