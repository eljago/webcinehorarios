'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText';

export default class PersonRow extends React.Component {
  static propTypes = {
    person: PropTypes.object,
    onEditPerson: PropTypes.func,
  };

  render() {
    const person = this.props.person;
    return (
      <a
        style={{
          ...styles.container,
          backgroundImage: `url(http://cinehorarios.cl${person.image.smallest.url})`,
          backgroundSize: 'cover'
        }}
        onClick={this.props.onEditPerson}
      >
        <div style={styles.content}>
          <span style={styles.span}>{person.name}</span>
          <span style={styles.span}>{person.id}</span>
          <span style={styles.span}>{person.imdb_code}</span>
        </div>
      </a>
    );
  }
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'row',
    margin: 4,
    cursor: 'pointer',
    width: 100,
    height: 140,
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