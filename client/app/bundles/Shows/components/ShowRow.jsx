'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash'

export default class ShowRow extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    index: PropTypes.number,
  };

  render() {
    const {show, index} = this.props;
    const {name, duration, year, rating, debut} = show
    return(
      <a
        style={{
          backgroundColor: (index % 2 == 0 ? 'white' : '#F1F1F1'),
          ...styles.container
        }} 
        href={`/admin/shows/${show.id}/edit`}
      >
        <img style={styles.img} src={`http://cinehorarios.cl${show.image_url}`}/>
        <div style={styles.content}>
          <span style={getColorStyle(name)}>{name ? name : 'NOMBRE'}</span>
          <span style={getColorStyle(duration)}>{duration ? duration : 'DURATION'}</span>
          <span style={getColorStyle(year)}>{year ? year : 'YEAR'}</span>
          <span style={getColorStyle(rating)}>{rating ? rating : 'RATING'}</span>
          <span style={getColorStyle(debut)}>
            {show.debut ? show.debut.split('-').reverse().join('-') : 'DEBUT'}
          </span>
        </div>
      </a>
    );
  }
}

function getColorStyle (text) {
  return {
    color: text ? 'black' : 'red'
  }
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'row',
    height: 120,
  },
  img: {
    width: 80,
    height: 120,
    objectFit: 'fill'
  },
  content: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    margin: 10,
  }
}
