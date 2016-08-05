'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';

import FormCast from './FormCast'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    onSubmit: PropTypes.func.isRequired,
    submitting: PropTypes.boolean,
    errors: PropTypes.object,
    getShowPersonRolesOptions: PropTypes.func
  };

  constructor(props) {
    super(props)
    _.bindAll(this, '_handleSubmit');
  }

  render() {
    const submitting = this.props.submitting;
    return (
      <div className="container">
        <ErrorMessages errors={this.props.errors} />
        <form>
          <Tabs defaultActiveKey={1} animation={false}>

            <Tab eventKey={1} title="Basic Info">
              <br/>
            </Tab>

            <Tab eventKey={2} title="Cast">
              <br/>
              <FormCast
                show_person_roles={this.props.show.show_person_roles}
                getShowPersonRolesOptions={this.props.getShowPersonRolesOptions}
                ref='formCast'
              />
            </Tab>

            <Tab eventKey={3} title="Images">
              <br/>
            </Tab>

            <Tab eventKey={4} title="Videos">
              <br/>
              <div/>
            </Tab>

          </Tabs>

          <br/>

          <Button
            type="submit"
            bsStyle="primary"
            disabled={submitting}
            onClick={!submitting ? this._handleSubmit : null}
          >
            {submitting ? 'Submitting...' : 'Submit'}
          </Button>

        </form>
      </div>
    );
  }

  _handleSubmit() {
    let showToSubmit = {}

    const dataShowCast = this.refs.formCast.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowCast);

    console.log(showToSubmit);
    this.props.onSubmit(showToSubmit);
  }
}
