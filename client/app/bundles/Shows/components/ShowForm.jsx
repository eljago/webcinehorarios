'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Button from 'react-bootstrap/lib/Button';
import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';

import ShowFormCast from './ShowFormCast'
import ShowFormBasic from './ShowFormBasic'
import ShowFormImages from './ShowFormImages'
import ShowFormVideos from './ShowFormVideos'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'


export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    genres: PropTypes.array,
    videoTypes: PropTypes.array,
    onSubmit: PropTypes.func.isRequired,
    submitting: PropTypes.boolean,
    errors: PropTypes.object,
    getShowPersonRolesOptions: PropTypes.func,
  };

  constructor(props) {
    super(props)
    _.bindAll(this, '_handleSubmit');
  }

  render() {
    const submitting = this.props.submitting;
    const showPersonRoles = this.props.show.show_person_roles ? this.props.show.show_person_roles : [];
    const showVideos = this.props.show.videos ? this.props.show.videos : [];
    const showImages = this.props.show.images ? this.props.show.images : [];

    return (
      <div className="container">
        <ErrorMessages errors={this.props.errors} />

        <Tabs bsStyle="pills" defaultActiveKey={1} animation={false}>

          <Tab eventKey={1} title="Basic Info">
            <br/>
            <ShowFormBasic
              show={this.props.show}
              genres={this.props.genres}
              ref='formBasic'
            />
          </Tab>

          <Tab eventKey={2} title="Cast">
            <br/>
            <ShowFormCast
              show_person_roles={showPersonRoles}
              getShowPersonRolesOptions={this.props.getShowPersonRolesOptions}
              ref='formCast'
            />
          </Tab>

          <Tab eventKey={3} title="Images">
            <br/>
            <ShowFormImages
              images={showImages}
              ref='formImages'
            />
          </Tab>

          <Tab eventKey={4} title="Videos">
            <br/>
            <ShowFormVideos
              videos={showVideos}
              videoTypes={this.props.videoTypes}
              ref='formVideos'
            />
          </Tab>

        </Tabs>

        <br/>

        <Button
          bsStyle="primary"
          disabled={submitting}
          onClick={!submitting ? this._handleSubmit : null}
        >
          {submitting ? 'Submitting...' : 'Submit'}
        </Button>

      </div>
    );
  }

  _handleSubmit() {
    let showToSubmit = {}

    const dataShowBasic = this.refs.formBasic.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowBasic);

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
