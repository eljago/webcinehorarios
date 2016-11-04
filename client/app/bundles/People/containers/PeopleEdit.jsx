'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import update from 'react/lib/update';

import PersonEdit from './PersonEdit'

import Button from 'react-bootstrap/lib/Button';

export default class PeopleEdit extends React.Component {

  static propTypes = {
    defaultPerson: PropTypes.object,
    onSuccess: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      people: [this._createNewPerson()]
    };
    _.bindAll(this, ['_onSuccess', '_createNewPerson', '_addNewPerson']);
  }

  render() {
    return (
      <div style={{marginBottom: 15}}>
        <div style={{display: 'flex', flexDirection: 'row', marginBottom: 10}}>
          {this.state.people.map((person, index) => {
            return (
              <PersonEdit
                key={person.key}
                onClose={() => this._onClose(index)}
                onSuccess={() => this._onSuccess(index)}
                person={person}
                ref={person.key}
              />
            );
          })}
        </div>
        <Button
          bsStyle="success"
          onClick={this._addNewPerson}
        >
          Nuevo
        </Button>
      </div>
    );
  }

  _addNewPerson() {
    this.setState({
      people: update(this.state.people, {$push: [this._createNewPerson()]})
    });
  }

  _createNewPerson(person = null) {
    return {
      ...(person ? person : this.props.defaultPerson),
      key: (new Date()).getTime()
    };
  }

  _onClose(index) {
    if (this.state.people.length == 1) {
      this.setState({
        people: update(this.state.people, {$splice: [[index, 1, this._createNewPerson()]]})
      });
    }
    else {
      this.setState({
        people: update(this.state.people, {$splice: [[index, 1]]})
      });
    }
  }

  _onSuccess(index) {
    this._onClose(index);
    this.props.onSuccess();
  }

  editPerson(person) {
    if (person && person.id) {
      const people = this.state.people;
      const ids = people.map((p) => p.id);
      if (!ids.includes(person.id)) {

        if (people.length == 1 && !people[0].id) {
          const result = this.refs[people[0].key].getResult();
          if (_.isEmpty(result)) {
            this.setState({
              people: update(people, {$splice: [[0, 1, person]]})
            });
            return;
          }
        }
        this.setState({
          people: update(people, {$push: [person]})
        });
      }
    }
  }
}
