'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'
import {
  Button,
  Form,
  Tabs,
  Tab,
} from 'react-bootstrap'

import ShowFormBasic from './ShowFormBasic'
import ShowFormCast from './ShowFormCast'

export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired,
    genres: PropTypes.array
  };
  static defaultProps = {
    genres: []
  };

  constructor(props) {
    super(props)
    this.state = {
      showChanges: Immutable.Map(),
    }
    _.bindAll(this,
      [
        '_handleSubmit',
        '_onChange',
      ]  
    )
  }

  render() {
    const {show, genres} = this.props;

    return (
      <div className="container">
        <Form horizontal ref={'form'}>
          <Tabs defaultActiveKey={1} animation={false} id="uncontrolled-tab-example">

            <Tab eventKey={1} title="Basic Info">
              <ShowFormBasic
                show={show}
                onChange={this._onChange}
                genres={genres}
              />
            </Tab>

            <Tab eventKey={2} title="Cast">
              <ShowFormCast
                cast={show.get('show_person_roles')}
              />
            </Tab>

            <Tab eventKey={3} title="Images">
              <div/>
            </Tab>

            <Tab eventKey={4} title="Videos">
              <div/>
            </Tab>

          </Tabs>

          <Button
            onClick={this._handleSubmit}
            target
            disabled={false}
            type="submit"
          >
            Submit
          </Button>

        </Form>
      </div>
    );
  }

  _onChange(controlId, value) {
    let valueToSet = value;

    if (_.isArray(valueToSet) && _.isEmpty(valueToSet)) {
      valueToSet = [" "];
    }

    const showChanges = this.state.showChanges.set(controlId, valueToSet);
    this.setState({showChanges});
    console.log(showChanges.toJS());
  }

  _handleSubmit() {
    let showChanges = this.state.showChanges;
    if (_.trim(showChanges.get('image')).length == 0) {
      showChanges = showChanges.delete('image');
    }
    if (_.trim(showChanges.get('remote_image_url')).length == 0) {
      showChanges = showChanges.delete('remote_image_url');
    }
    else {
      // don't send file image if remote_image_url is present
      showChanges = showChanges.delete('image');
    }
    this.props.handleSubmit(showChanges);
  }
}
