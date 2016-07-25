'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';

import FormBuilderShowBasic from '../../../lib/forms/FormBuilders/FormBuilderShowBasic'
import ShowFormBasic from './ShowFormBasic'
import ShowFormCast from './ShowFormCast'

export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    onSubmit: PropTypes.func.isRequired,
    genres: PropTypes.array,
    canSubmit: PropTypes.boolean,
    getPeopleOptions: PropTypes.func,
  };
  static defaultProps = {
    genres: []
  };

  constructor(props) {
    super(props)
    _.bindAll(this, '_handleSubmit');
    this.formBuilderBasic = new FormBuilderShowBasic(props.genres);
  }

  render() {
    return (
      <div className="container">
        <form>
          <Tabs defaultActiveKey={1} animation={false} id="uncontrolled-tab-example">

            <Tab eventKey={1} title="Basic Info">
              <ShowFormBasic
                formBuilder={this.formBuilderBasic}
                ref='formBasic'
                show={this.props.show}
              />
            </Tab>

            <Tab eventKey={2} title="Cast">
              <ShowFormCast
                ref='formCast'
                controlId="show_person_roles_attributes"
                cast={this.props.show.show_person_roles}
                getPeopleOptions={this.props.getPeopleOptions}
              />
            </Tab>

            <Tab eventKey={3} title="Images">
              <div/>
            </Tab>

            <Tab eventKey={4} title="Videos">
              <div/>
            </Tab>

          </Tabs>

          <br/>

          <Button
            onClick={this._handleSubmit}
            target
            disabled={!this.props.canSubmit}
            type="submit"
          >
            Submit
          </Button>

        </form>
      </div>
    );
  }

  _handleSubmit() {
    let showToSubmit = this.refs.formBasic.getResult();
    if (showToSubmit.image && !_.isEmpty(showToSubmit.image)) {
      _.unset(showToSubmit,'remote_image_url');
    }
    console.log(showToSubmit);
    this.props.onSubmit(showToSubmit);
  }
}
