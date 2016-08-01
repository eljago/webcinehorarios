'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';

import ShowFormBasic from './ShowFormBasic'
import ShowFormCast from './ShowFormCast'
import ShowFormImages from './ShowFormImages'
import ShowFormVideos from './ShowFormVideos'

import FormBuilderShow from '../../../lib/forms/FormBuilders/FormBuilderShow'
import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

export default class ShowForm extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilderShow),
    onSubmit: PropTypes.func.isRequired,
    submitting: PropTypes.boolean,
    errors: PropTypes.object,
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
          <Tabs defaultActiveKey={1} animation={false} id="uncontrolled-tab-example">

            <Tab eventKey={1} title="Basic Info">
              <br/>
              <ShowFormBasic
                formBuilder={this.props.formBuilder}
                ref='formBasic'
              />
            </Tab>

            <Tab eventKey={2} title="Cast">
              <br/>
              <ShowFormCast
                formBuilder={this.props.formBuilder}
                ref='formCast'
              />
            </Tab>

            <Tab eventKey={3} title="Images">
              <br/>
              <ShowFormImages
                formBuilder={this.props.formBuilder}
                ref='formImages'
              />
            </Tab>

            <Tab eventKey={4} title="Videos">
              <br/>
              <ShowFormVideos
                formBuilder={this.props.formBuilder}
                ref='formVideos'
              />
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
    let showToSubmit = this.refs.formBasic.getResult();

    const dataShowCast = this.refs.formCast.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowCast);

    const dataShowImages = this.refs.formImages.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowImages);

    const dataShowVideos = this.refs.formVideos.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowVideos);

    console.log(showToSubmit);
    this.props.onSubmit(showToSubmit);
  }
}
