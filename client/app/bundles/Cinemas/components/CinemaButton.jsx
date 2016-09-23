'use strict';

import React, { PropTypes } from 'react';

export default class CinemaButton extends React.Component {

  static propTypes = {
    text: PropTypes.string,
    imageUrl: PropTypes.string,
    onClick: PropTypes.func,
    selected: PropTypes.boolean,
  };
  
  render() {
    return (
      <a
        onClick={this.props.onClick}
        style={{
          margin: 10,
          width: 90,
          height: 90,
          backgroundImage: `url(http://cinehorarios.cl${this.props.imageUrl})`,
          backgroundSize: '100%',
          textAlign: 'center',
          textDecoration: 'none',
          borderRadius: 20,
          borderStyle: this.props.selected ? 'solid' : 'hidden',
          borderColor: 'black',
          borderWidth: 3,
          cursor: this.props.selected ? 'auto' : 'pointer',
        }}
      >
        <div style={{
          backgroundColor: `rgba(0,0,0,${this.props.selected ? '0' : '0.4'})`,
          backgroundSize: '100%',
          width: '100%',
          height: '100%',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          borderRadius: 20,
        }}>
          <span style={{
            color: 'white',
            fontSize: 16,
            fontWeight: 500,
            display: this.props.selected ? 'none' : 'inline',
          }}>
            {this.props.text}
          </span>
        </div>
      </a>
    );
  }
}