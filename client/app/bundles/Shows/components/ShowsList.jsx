'use strict';

import React, { PropTypes } from 'react';

export default class ShowsList extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    loadingContent: PropTypes.boolean,
  };

  render() {
    return (
      <div style={styles.container}>
        {this._getContent()}
      </div>
    )
  }

  _getContent() {
    if (this.props.loadingContent) {
      return <h1>Loading ...</h1>;
    }
    else {
      return this.props.shows.map((show, i) => {
        return(
          <a
            key={show.id}
            style={{
              ...styles.a,
              backgroundImage: `url(${show.image_url})`,
              backgroundSize: 'cover'
            }}
            href={`/admin/shows/${show.id}/edit`}
          >
            <div style={styles.content}>
              <span style={styles.span}>{show.name}</span>
              <span style={styles.span}>{show.duration}</span>
              <span style={styles.span}>{show.year}</span>
              <span style={styles.span}>{show.debut ? show.debut.split('-').reverse().join('-') : ''}</span>
            </div>
          </a>
        );
      });
    }
  }
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },
  a: {
    display: 'flex',
    flexDirection: 'row',
    margin: 4,
    cursor: 'pointer',
    width: 110,
    height: 160,
  },
  content: {
    backgroundColor: `rgba(0,0,0,0.6)`,
    width: '100%',
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  span: {
    textAlign: 'center',
    color: 'white',
  },
}
