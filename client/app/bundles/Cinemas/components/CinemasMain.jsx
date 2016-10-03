'use strict';

import React, { PropTypes } from 'react';

import CinemaButton from './CinemaButton';

export default class CinemasMain extends React.Component {

  static propTypes = {
    cinemas: PropTypes.array,
    theaters: PropTypes.array,
    selectedCinemaId: PropTypes.number,
    onClickCinema: PropTypes.func,
    loadingTheaters: PropTypes.boolean,
    errors: PropTypes.object,
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
          <button onClick={() => {
            window.location.assign(`/admin/cinemas/${this.props.selectedCinemaId}/theaters/new`)
          }}>
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
    if (this.props.loadingTheaters) {
      return <h1>Loading...</h1>;
    }
    else {
      return this.props.theaters.map((theater) => {
        return (
          <div
            style={{
              display: 'flex',
              justifyContent: 'flex-start',
              margin: 5,
            }}
          >
            <a style={{flex: 1}} href={`/admin/theaters/${theater.slug}/functions`}>
              {theater.name}
            </a>
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
}