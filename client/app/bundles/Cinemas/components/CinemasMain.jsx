'use strict';

import React, { PropTypes } from 'react';

import CinemaButton from './CinemaButton';

export default class CinemasMain extends React.Component {

  static propTypes = {
    cinemas: PropTypes.array,
    theaters: PropTypes.array,
    selectedCinemaId: PropTypes.number,
    onClickCinema: PropTypes.func,
  };

  constructor(props) {
    super(props);
  }
  
  render() {
    return (
      <div>
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'center',
          flexWrap: 'wrap',
        }}>
          {this._getButtons()}
        </div>
        <div>
          <button
            onClick={() => {
              window.location.assign(`/admin/theaters/new`)
            }}
          >
            Nuevo
          </button>
        </div>
        <div>
          {this._getTheaters()}
        </div>
      </div>
    );
  }

  _getButtons() {
    return this.props.cinemas.map((cinema) => {
      return (
        <CinemaButton
          text={cinema.name}
          onClick={() => this.props.onClickCinema(cinema.id)}
          imageUrl={cinema.image.url}
          selected={cinema.id === this.props.selectedCinemaId}
        />
      );
    });
  }

  _getTheaters() {
    return this.props.theaters.map((theater) => {
      return (
        <div
          style={{
            display: 'flex',
            justifyContent: 'flex-start',
            margin: 5,
          }}
        >
          <span style={{
            flex: 1
          }}>
            {theater.name}
          </span>
          <button
            style={{
              alignSelf: 'flex-end'
            }}
            onClick={() => {
              window.location.assign(`/admin/theaters/${theater.slug}/edit`)
            }}>
            Editar
          </button>
        </div>
      );
    });
  }
}