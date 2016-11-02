'use strict';

import React, { PropTypes } from 'react';

export default class ShowRow extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    index: PropTypes.number,
  };

  render() {
    const {show, index} = this.props;
    return(
      <a
        style={{
          backgroundColor: (index % 2 == 0 ? 'white' : '#F1F1F1'),
          ...styles.container
        }} 
        href={`/admin/shows/${show.id}/edit`}
      >
        <img style={styles.img} src={show.image_url}/>
        <div style={styles.content}>
          <span style={styles.span}>{show.name}</span>
          <span style={styles.span}>{show.duration}</span>
          <span style={styles.span}>{show.year}</span>
          <span style={styles.span}>{show.debut ? show.debut.split('-').reverse().join('-') : ''}</span>
        </div>
      </a>
    );
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
  },
  span: {
    textDecoration: 'none',
    color: 'black',
  },
}
