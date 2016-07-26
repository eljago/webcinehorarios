'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';

import ShowFormBasic from './ShowFormBasic'
import ShowFormCast from './ShowFormCast'

import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'

export default class ShowForm extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilderShow),
    onSubmit: PropTypes.func.isRequired,
    canSubmit: PropTypes.boolean,
  };

  constructor(props) {
    super(props)
    _.bindAll(this, '_handleSubmit');
  }

  render() {
    return (
      <div className="container">
        <form>
          <Tabs defaultActiveKey={1} animation={false} id="uncontrolled-tab-example">

            <Tab eventKey={1} title="Basic Info">
              <ShowFormBasic
                formBuilder={this.props.formBuilder}
                ref='formBasic'
              />
            </Tab>

            <Tab eventKey={2} title="Cast">
              <ShowFormCast
                formBuilder={this.props.formBuilder}
                ref='formCast'
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
